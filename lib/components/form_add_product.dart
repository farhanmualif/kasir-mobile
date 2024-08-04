import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasir_mobile/components/barcode_camera.dart';
import 'package:kasir_mobile/interface/category_interface.dart';
import 'package:kasir_mobile/provider/get_category_provider.dart';
import 'package:kasir_mobile/provider/post_product_provider.dart';
import 'package:kasir_mobile/themes/AppColors.dart';

class FormAddProduct extends StatefulWidget {
  const FormAddProduct({super.key});

  @override
  State<FormAddProduct> createState() => _FormAddProductState();
}

class _FormAddProductState extends State<FormAddProduct> {
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

  Future _pickImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (mounted) {
      setState(() {
        _selectedImage = image != null ? File(image.path) : null;
      });
    }
  }

  Future _pickImageFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (mounted) {
      setState(() {
        _selectedImage = image != null ? File(image.path) : null;
      });
    }
  }

  postProduct(BuildContext context) async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      if (int.parse(_purchasePriceController.text) >=
          int.parse(_sellingPriceController.text)) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 5),
          content: Text("Harga jual harus lebih besar dari harga beli"),
          backgroundColor: Colors.red,
        ));
        return;
      }

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
        Navigator.pushReplacementNamed(context, '/payment-done',
            arguments: {'typeTransaction': 'Pembelian Barang', 'change': 0});
        // Navigator.pushReplacement(
        //     // ignore: use_build_context_synchronously
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => PaymentDone(
        //               change: 0,
        //               typeTransaction: "Pembelian Barang",
        //             )));
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
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future getAllCategory() async {
    try {
      final apiResponse = await GetCategory.getCategory();
      if (apiResponse.status) {
        final categories = apiResponse.data;
        if (mounted) {
          setState(() {
            allCategories.addAll(categories!);
          });
        }
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
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          )
        : Form(
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                image: DecorationImage(
                                  image: _selectedImage != null
                                      ? FileImage(_selectedImage!)
                                      : const AssetImage(
                                              'assets/images/default-product.png')
                                          as ImageProvider<Object>,
                                ),
                              )),
                          Container(
                            margin: const EdgeInsets.only(top: 13, bottom: 13),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: GestureDetector(
                                        onTap: () {
                                          _pickImageFromGallery();
                                        },
                                        child: const Icon(Icons.image_search))),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      _pickImageFromCamera();
                                    },
                                    child: const Icon(Icons.camera_alt),
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
                        if (value == null || value.isEmpty) {
                          return "nama barang tidak boleh kosong";
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "stock tidak boleh kosong";
                                  }
                                  return null;
                                },
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
                            const Text("barcode*"),
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
                                        if (mounted) {
                                          setState(() {
                                            _codeController.text = barcodeRes;
                                          });
                                        }
                                      } catch (e) {
                                        rethrow;
                                      }
                                    },
                                    child: const RotationTransition(
                                      turns: AlwaysStoppedAnimation(1 / 4),
                                      child: Image(
                                          image: AssetImage(
                                              "assets/images/barcode.png")),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Harga dasar tidak boleh kosong";
                                  }
                                  return null;
                                },
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Harga jual tidak boleh kosong";
                                  }
                                  return null;
                                },
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
                        if (mounted) {
                          setState(() {
                            _idCategorySelected = newVal!;
                          });
                        }
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
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState != null &&
                              _formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                          }
                          if (_productNameController.text.isNotEmpty &&
                              _purchasePriceController.text.isNotEmpty &&
                              _sellingPriceController.text.isNotEmpty &&
                              _stockController.text.isNotEmpty) {
                            postProduct(context);
                          } else {
                            return;
                          }
                        },
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
          );
  }
}
