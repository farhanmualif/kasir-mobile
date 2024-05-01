import 'package:flutter/material.dart';
import 'package:kasir_mobile/provider/post_category.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final _addCategoryController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff076A68),
        title: const Text(
          "Tambah Kategori",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
            left: 50, right: 50, top: MediaQuery.of(context).size.height * 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Tambah Kategori',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 37),
            TextField(
              controller: _addCategoryController,
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
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  var response = await postCategory();
                  setState(() {
                    _isLoading = false;
                  });
                  if (response["status"] == false) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: const Duration(seconds: 5),
                      content: Text(response['message']),
                      backgroundColor: Colors.red,
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: const Duration(seconds: 5),
                      content: Text(response['message']),
                      backgroundColor: Colors.green,
                    ));
                  }
                },
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('Simpan',
                        style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future postCategory() async {
    try {
      var response = await PostCategory.post(_addCategoryController.text);
      Map<String, dynamic> resBody = {
        "status": response.status,
        "message": response.message
      };
      return resBody;
    } catch (e) {
      return e.toString();
    }
  }
}
