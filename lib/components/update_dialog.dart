import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UpdateDialog {
  UpdateDialog({required this.dataProduct});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _typeChange = "";
  // ignore: prefer_typing_uninitialized_variables
  var dataProduct;

  Future<Widget> showEditingFormDialog(
    BuildContext context,
  ) async {
    var domain = dotenv.env['BASE_URL'];
    return await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: SizedBox(
              height: 410,
              child: Form(
                key: _formKey,
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Manajemen Stok",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            flex: -1,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(50)),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                    "https://$domain/storage/images/${dataProduct.image}",
                                  ))),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dataProduct.name,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "code:  ${dataProduct.barcode ?? 0}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Rp. ${dataProduct.sellingPrice}",
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Stok: ${dataProduct.stock}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Radio(
                                  value: "reduce",
                                  groupValue: _typeChange,
                                  onChanged: (value) {
                                    setState(() {
                                      _typeChange = value!;
                                    });
                                  },
                                ),
                                const Text("Tambah"),
                                Radio(
                                  value: "add",
                                  groupValue: _typeChange,
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        _typeChange = value!;
                                      },
                                    );
                                  },
                                ),
                                const Text("Kurangi")
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Icons.calendar_month_outlined,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Klik untuk Menentukan Tanggal",
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Harga Dasar",
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.33,
                                child: TextFormField(
                                  initialValue: "${dataProduct.purchasePrice}",
                                  decoration: const InputDecoration(
                                    prefixText: "Rp. ",
                                    hintStyle: TextStyle(fontSize: 15),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                    ),
                                    isCollapsed: true,
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Jumlah",
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.33,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    hintStyle: TextStyle(fontSize: 15),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                    ),
                                    isCollapsed: true,
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Keterangan",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(fontSize: 15),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                            isCollapsed: true,
                            isDense: true,
                            contentPadding: EdgeInsets.all(5),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 34,
                              decoration: const BoxDecoration(
                                  color: Color(0xffFFCA45),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: const TextButton(
                                onPressed: null,
                                child: Text(
                                  "Batal",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Container(
                              height: 34,
                              decoration: const BoxDecoration(
                                  color: Color(0xff076A68),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: const TextButton(
                                onPressed: null,
                                child: Text(
                                  "Simpan",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
