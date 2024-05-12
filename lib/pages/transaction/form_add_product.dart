import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasir_mobile/components/barcode_camera.dart';
import 'package:kasir_mobile/interface/category_interface.dart';
import 'package:kasir_mobile/pages/transaction/payment_done.dart';
import 'package:kasir_mobile/provider/get_category.dart';
import 'package:kasir_mobile/provider/post_product.dart';

class FormAddProductPage extends StatefulWidget {
  const FormAddProductPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FormAddProductPageState createState() => _FormAddProductPageState();
}

class _FormAddProductPageState extends State<FormAddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _stockController = TextEditingController();
  final _codeController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  late String? setBarcodeResult;

  String _idCategorySelected = '';
  List<CategoryProduct> allCategories = [];

  File? _selectedImage;
   
  bool _isLoading = false;

  postProduct() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final post = await PostProduct.postProduct(
          image: _selectedImage,
          name: _productNameController.text,
          purchasePrice: int.parse(_purchasePriceController.text),
          sellingPrice: int.parse(_sellingPriceController.text),
          barcode: _codeController.text,
          categoryId: _idCategorySelected.isNotEmpty
              ? int.tryParse(_idCategorySelected) ?? 0
              : null,
          stock: int.parse(_stockController.text));

      if (post['status'] == true) {
        Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
                builder: (context) => PaymentDone(
                      change: 0,
                      typeTransaction: "Pembelian Barang",
                    )));
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => const Struk()));
      } else {
        final snackBar = SnackBar(
          duration: const Duration(seconds: 5),
          content: Text(post['message']),
          backgroundColor: Colors.red,
        );

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      final snackBar = SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      );

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future getAllCategory() async {
    try {
      final apiResponse = await GetCategory.getCategory();
      if (apiResponse.status) {
        final categories = apiResponse.data;
        setState(() {
          allCategories.addAll(categories!);
        });
      } else {
        return ArgumentError("Terjadi error");
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    getAllCategory();

    // print("cek kategori: $productCategories");
  }

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
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.9,
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 120,
                          margin: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Column(
                            children: [
                              Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    image: DecorationImage(
                                      image: _selectedImage != null
                                          ? FileImage(_selectedImage!)
                                          : const AssetImage(
                                                  'assets/images/default-product.png')
                                              as ImageProvider<Object>,
                                    ),
                                  )),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 13, bottom: 13),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: GestureDetector(
                                            onTap: () {
                                              _pickImageFromGallery();
                                            },
                                            child: const Icon(
                                                Icons.image_search))),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          _pickImageFromCamera();
                                        },
                                        child: GestureDetector(
                                          onTap: () async {
                                            try {
                                              try {
                                                var barcodeResult =
                                                    await BarcodeCamera()
                                                        .scanner();

                                                setState(() {
                                                  _codeController.text =
                                                      barcodeResult;
                                                });
                                              } catch (e) {
                                                rethrow;
                                              }
                                            } catch (e) {
                                              rethrow;
                                            }
                                          },
                                          child: const Icon(
                                              Icons.qr_code_scanner_outlined),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const Text('Nama Barang*'),
                      const SizedBox(height: 10),
                      SizedBox(
                        child: TextFormField(
                          controller: _productNameController,
                          decoration: const InputDecoration(
                            isDense: true,
                            isCollapsed: true,
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Nama barang harus diisi';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Stok*"),
                                const SizedBox(height: 10),
                                SizedBox(
                                  child: TextFormField(
                                    controller: _stockController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      isCollapsed: true,
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(50),
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Stok harus diisi';
                                      }
                                      return null;
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Kode*"),
                                const SizedBox(height: 10),
                                SizedBox(
                                  child: TextFormField(
                                    controller: _codeController,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      isCollapsed: true,
                                      contentPadding: const EdgeInsets.all(10),
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(50),
                                        ),
                                      ),
                                      suffixIcon: GestureDetector(
                                        onTap: () async {
                                          try {
                                            String barcodeRes =
                                                await BarcodeCamera().scanner();
                                            setState(() {
                                              _codeController.text = barcodeRes;
                                            });
                                          } catch (e) {
                                            rethrow;
                                          }
                                        },
                                        child: const Icon(Icons.qr_code),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Kode harus diisi';
                                      }
                                      return null;
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 15, left: 5),
                              child: const Icon(Icons.replay_outlined))
                        ],
                      ),
                      const SizedBox(
                        height: 11,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Harga Dasar*"),
                                const SizedBox(height: 10),
                                SizedBox(
                                  child: TextFormField(
                                    controller: _purchasePriceController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        isDense: true,
                                        isCollapsed: true,
                                        contentPadding: EdgeInsets.all(10),
                                        prefixText: 'Rp ',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(50),
                                          ),
                                        )),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Harga dasar harus diisi';
                                      }
                                      return null;
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Harga Jual*"),
                                const SizedBox(height: 10),
                                SizedBox(
                                  child: TextFormField(
                                    controller: _sellingPriceController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        isDense: true,
                                        isCollapsed: true,
                                        contentPadding: EdgeInsets.all(10),
                                        prefixText: 'Rp ',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(50),
                                          ),
                                        )),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Harga jual harus diisi';
                                      }
                                      return null;
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      const Text('kategori'),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        child: DropdownButton<String>(
                          hint: const Text('Pilih Kategori'),
                          items: allCategories.map((item) {
                            return DropdownMenuItem<String>(
                              value: "${item.id}",
                              child: Text(item.name),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              _idCategorySelected = newVal!;
                            });
                          },
                          value: _idCategorySelected.isNotEmpty
                              ? _idCategorySelected
                              : null,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(height: 16.0),
                      const SizedBox(height: 16.0),
                      Center(
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.8,
                          margin: const EdgeInsets.only(right: 10, top: 10),
                          decoration: const BoxDecoration(
                              color: Color(0xffFFCA45),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: TextButton(
                            onPressed: postProduct,
                            child: const Text(
                              "Simpan",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Future _pickImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = image != null ? File(image.path) : null;
    });
  }

  Future _pickImageFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _selectedImage = image != null ? File(image.path) : null;
    });
  }
}
