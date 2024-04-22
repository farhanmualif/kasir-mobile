
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Struk extends StatefulWidget {
  const Struk({super.key, this.url});
  final String? url;

  @override
  State<Struk> createState() => _StrukState();
}

class _StrukState extends State<Struk> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Struk"),
      ),
      body: widget.url!= null  ? SfPdfViewer.network(widget.url!) :const Text("Not found"),
    );
  }

  
}
