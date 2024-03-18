import 'package:flutter/material.dart';
import 'package:kasir_mobile/pages/management/edit_category.dart';

class ProductCategory extends StatelessWidget {
  const ProductCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff076A68),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Kategori Produk",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Color(0xffD9D9D9)))),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: const Icon(Icons.filter_list_outlined),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Cari Categori",
                        suffixIcon: const Icon(
                          Icons.search,
                          size: 35,
                        ),
                        isDense: true,
                        isCollapsed: true,
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7933,
              child: ListView.builder(
                itemCount: 50,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: const Text("shampo"),
                    subtitle: const Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Row(
                            children: [
                              Expanded(child: Text('sisa 20')),
                              Expanded(child: Text('Modal: Rp. 20000')),
                            ],
                          ),
                        ),
                      ],
                    ),
                    trailing: Column(
                      children: [
                        Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const CategoryModifier()));
                                },
                                child: const Icon(Icons.edit_square))),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              debugPrint("deleted clicked");
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
