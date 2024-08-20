import 'package:flutter/material.dart';
import 'package:kasir_mobile/pages/struk/print_preparation.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/helper/get_access_token.dart';

class Struk extends StatefulWidget {
  const Struk({super.key, this.noTransaction});
  final String? noTransaction;

  @override
  State<Struk> createState() => _StrukState();
}

class _StrukState extends State<Struk> with AccessTokenProvider {
  String? _accessToken;
  bool _isLoading = true;
  var domain = dotenv.env['BASE_URL'];

  @override
  void initState() {
    super.initState();
    _initializeToken();
  }

  Future<void> _initializeToken() async {
    _accessToken = await getToken();
    setState(() {
      _isLoading = false; // Token telah diinisialisasi
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Struk"),
        ),
        body: const Center(
            child:
                CircularProgressIndicator()), // Menampilkan indikator loading
      );
    }

    final url = "$domain/api/transaction/${widget.noTransaction}/invoice";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Struk"),
      ),
      body: Column(
        children: [
          Expanded(
              child: widget.noTransaction != null
                  ? SfPdfViewer.network(
                      url,
                      initialZoomLevel: 5,
                      headers: _accessToken != null
                          ? {"Authorization": "Bearer $_accessToken"}
                          : throw Exception(" Access Token Not Found"),
                    )
                  : const Center(child: Text("Not found"))),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>  PrintPreparation(noTransaction: widget.noTransaction!,),
              ));
            },
            child: const Text('Cetak Struk'),
          ),
        ],
      ),
    );
  }
}
