import 'package:flutter/material.dart';

class CategoryModifier extends StatefulWidget {
  const CategoryModifier({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CategoryModifierState createState() => _CategoryModifierState();
}

class _CategoryModifierState extends State<CategoryModifier> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff076A68),
        title: const Text(
          "Edit Kategori",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
            left: 50, right: 50, top: MediaQuery.of(context).size.height * 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Ubah Kategori',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 37),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Masukkan Nama Kategori',
                isCollapsed: true,
                isDense: true,
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: const BoxDecoration(
                  color: Color(0xff076A68),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextButton(
                onPressed: () {
                  // Handle save action here
                  debugPrint('Kategori baru : ${_controller.text}');
                },
                child:
                    const Text('Simpan', style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
