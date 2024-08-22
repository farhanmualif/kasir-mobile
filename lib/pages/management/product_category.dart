import 'package:flutter/material.dart';
import 'package:kasir_mobile/helper/format_cuurency.dart';
import 'package:kasir_mobile/pages/management/add_category.dart';
import 'package:kasir_mobile/pages/management/edit_category.dart';
import 'package:kasir_mobile/provider/delete_category_provider.dart';
import 'package:kasir_mobile/provider/get_category_provider.dart';

class ProductCategory extends StatefulWidget {
  const ProductCategory({super.key});

  @override
  State<ProductCategory> createState() => _ProductCategoryState();
}

class _ProductCategoryState extends State<ProductCategory> {
  bool _isLoading = false;

  Future<void> _refreshCategories() async {
    setState(() {});
  }

  Future<Map<String, dynamic>> deleteCategory(String uuid) async {
    try {
      var response = await DeleteCategory.delete(uuid);
      return {"status": response.status, "message": response.message};
    } catch (e) {
      rethrow;
    }
  }

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
      body: RefreshIndicator(
        onRefresh: _refreshCategories,
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                _buildSearchBar(context),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7933,
                  child: _buildCategoryList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20, top: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Color(0xffD9D9D9)),
        ),
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: const Icon(Icons.filter_list_outlined),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari Kategori",
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
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddCategory(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return FutureBuilder(
      future: GetCategory.getCategory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.data == null) {
          return const Center(child: Text('Tidak ada data kategori tersedia'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.data!.length,
            itemBuilder: (context, index) {
              return _buildCategoryItem(snapshot, index);
            },
          );
        }
      },
    );
  }

  Widget _buildCategoryItem(AsyncSnapshot snapshot, int index) {
    var category = snapshot.data!.data![index];
    return ListTile(
      title: Text(category.name),
      subtitle: Row(
        children: [
          Expanded(
            flex: 7,
            child: Row(
              children: [
                Expanded(
                  child: Text('Sisa: ${category.remainingStock}'),
                ),
                Expanded(
                  child: Text(
                    'Modal: ${convertToIdr(int.parse(category.capital!.replaceAll('.00', '')))}',
                  ),
                ),
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CategoryModifier(
                      categoryUUID: category.uuid!,
                      categoryName: category.name,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.edit_square),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                _showDeleteConfirmationDialog(context, category.uuid!);
              },
              child: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String uuid) {
    showDialog(
      context: context,
      builder: (context) => _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : AlertDialog(
              title: const Text('Konfirmasi Hapus'),
              content:
                  const Text('Apakah Anda yakin ingin menghapus kategori ini?'),
              actions: [
                TextButton(
                  child: const Text('Batal'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Hapus'),
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    var response = await deleteCategory(uuid);
                    if (response["status"] == false) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 5),
                            content: Text(response['message']),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 5),
                            content: Text(response['message']),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    }
                    setState(() {
                      _isLoading = false;
                    });
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
    );
  }
}
