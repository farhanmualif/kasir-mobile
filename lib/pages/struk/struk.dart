import 'package:flutter/material.dart';
import 'package:kasir_mobile/pages/struk/print_preparation.dart';
import 'package:kasir_mobile/themes/AppColors.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/helper/get_access_token.dart';

class Struk extends StatefulWidget {
  const Struk({super.key, this.noTransaction});
  final String? noTransaction;

  @override
  State createState() => _StrukState();
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

  Future _initializeToken() async {
    try {
      _accessToken = await getToken();
    } catch (e) {
      _showErrorSnackBar("Gagal mendapatkan token: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Struk"),
          backgroundColor: AppColors.primary,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final url = "$domain/api/transaction/${widget.noTransaction}/invoice";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Struk"),
      ),
      body: Column(
        children: [
          _buildPdfContent(url),
          _buildButtonPreparePrint(),
        ],
      ),
    );
  }

  Widget _buildPdfContent(String url) {
    return Expanded(
      child: widget.noTransaction != null
          ? SfPdfViewer.network(
              url,
              initialZoomLevel: 5,
              headers: _accessToken != null
                  ? {"Authorization": "Bearer $_accessToken"}
                  : {},
              onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                _showErrorSnackBar("Gagal memuat PDF: ${details.error}");
              },
            )
          : const Center(child: Text("Not found")),
    );
  }

  Widget _buildButtonPreparePrint() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: AppColors.primary,
          fixedSize: Size.fromWidth(MediaQuery.of(context).size.width * 0.8)),
      onPressed: () {
        if (widget.noTransaction != null) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                PrintPreparation(noTransaction: widget.noTransaction!),
          ));
        } else {
          _showErrorSnackBar("Nomor transaksi tidak tersedia");
        }
      },
      child: const Text(
        'Cetak Struk',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
