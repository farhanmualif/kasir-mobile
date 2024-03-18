import 'package:flutter/material.dart';

class StokProductManagement extends StatelessWidget {
  const StokProductManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff076A68),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Manajemen Stok",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
