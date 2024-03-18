import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasir_mobile/pages/struk.dart';

class FormAddProductPage extends StatefulWidget {
  const FormAddProductPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FormAddProductPageState createState() => _FormAddProductPageState();
}

class _FormAddProductPageState extends State<FormAddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaBarangController = TextEditingController();
  final _stokController = TextEditingController();
  final _kodeController = TextEditingController();
  final _hargaDasarController = TextEditingController();
  final _hargaJualController = TextEditingController();
  String _kategori = '';

  File? _selectedImage;

  List<String> listKategori = ["Makanan", "Minuman", "Peralatan Mandi"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff076A68),
        iconTheme:const IconThemeData(color: Colors.white),
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
                                        child: const Icon(Icons.camera_alt))),
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
                      controller: _namaBarangController,
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
                                controller: _stokController,
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
                                controller: _kodeController,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  isCollapsed: true,
                                  contentPadding: EdgeInsets.all(10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50),
                                    ),
                                  ),
                                  suffixIcon: Icon(Icons.qr_code),
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
                                controller: _hargaDasarController,
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
                                controller: _hargaJualController,
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
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                          isCollapsed: true,
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                          )),
                      value: _kategori.isNotEmpty ? _kategori : null,
                      onChanged: (value) {
                        setState(() {
                          _kategori = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kategori harus dipilih';
                        }
                        return null;
                      },
                      items: listKategori
                          .map<DropdownMenuItem<String>>((String item) {
                        return DropdownMenuItem<String>(
                            value: item, child: Text(item));
                      }).toList(),
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Struk()));
                        },
                        child: const Text(
                          "Lanjut",
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
