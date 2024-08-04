
import 'package:flutter/material.dart';
import 'package:kasir_mobile/components/form_add_product.dart';

class AddProoductPage extends StatefulWidget {
  const AddProoductPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddProoductPageState createState() => _AddProoductPageState();
}

class _AddProoductPageState extends State<AddProoductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff076A68),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Tambah Barang',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Container(
            height: 30,
            margin: const EdgeInsets.only(right: 10, top: 10),
            decoration: const BoxDecoration(
                color: Color(0xffFFCA45),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: const TextButton(
              onPressed: null,
              child: Text(
                "Tambah Instan",
                style: TextStyle(color: Colors.black, fontSize: 10),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          padding: const EdgeInsets.all(16.0),
          child: const FormAddProduct(),
        ),
      ),
    );
  }
}
