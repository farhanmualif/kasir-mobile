import 'package:flutter/material.dart';
import 'package:kasir_mobile/provider/update_category.dart';

class CategoryModifier extends StatefulWidget {
  const CategoryModifier(
      {super.key, required this.categoryUUID, required this.categoryName});

  final String categoryUUID;
  final String categoryName;

  @override
  // ignore: library_private_types_in_public_api
  _CategoryModifierState createState() => _CategoryModifierState();
}

class _CategoryModifierState extends State<CategoryModifier> {
  final _newNameController = TextEditingController();
  bool _isLoading = false;

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
              controller: _newNameController,
              decoration: InputDecoration(
                labelText: 'Masukkan Nama Kategori',
                hintText: widget.categoryName,
                isCollapsed: true,
                isDense: true,
                contentPadding: const EdgeInsets.all(10),
                border: const OutlineInputBorder(
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
                  try {
                    setState(() {
                      _isLoading = true;
                    });
                    var response = await updateCategory();
                    setState(() {
                      _isLoading = false;
                    });
                    if (response["sattus"] == false) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: const Duration(seconds: 5),
                        content: Text(response['message']),
                        backgroundColor: Colors.red,
                      ));
                    } else {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: const Duration(seconds: 5),
                        content: Text(response['message']),
                        backgroundColor: Colors.green,
                      ));
                    }
                  } catch (e) {
                    rethrow;
                  }
                },
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
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

  Future updateCategory() async {
    try {
      var respose = await UpdateCategory.post(
          widget.categoryUUID, _newNameController.text);
      return {
        "status": respose.status,
        "message": respose.message,
      };
    } catch (e) {
      return e;
    }
  }
}
