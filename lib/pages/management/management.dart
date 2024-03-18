import 'package:flutter/material.dart';
import 'package:kasir_mobile/pages/management/product_category.dart';
import 'package:kasir_mobile/pages/management/stok_product.dart';

class Management extends StatelessWidget {
  const Management({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff076A68),
        title: const Text(
          "Manajemen",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const StokProductManagement()),
              );
            },
            child: const ListTile(
              leading: Icon(Icons.note_alt_outlined),
              title: Text(
                "Stok Produk",
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ProductCategory()));
            },
            child: const ListTile(
              leading: Icon(
                Icons.category_outlined,
              ),
              title: Text("Kategori Produk",
                  style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          )
        ],
      ),
    );
  }
}
