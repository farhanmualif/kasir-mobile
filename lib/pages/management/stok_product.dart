import 'package:flutter/material.dart';

class StokProductManagement extends StatefulWidget {
  const StokProductManagement({super.key});

  @override
  State<StokProductManagement> createState() => _StokProductManagementState();
}

class _StokProductManagementState extends State<StokProductManagement> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _typeChange = "";

  Future<void> showEditingFormDialog(BuildContext context) async {
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
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                  image: DecorationImage(
                                      image: AssetImage(
                                    "assets/images/default-product.png",
                                  ))),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Aqua Galon",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "898928756327",
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Rp. 200000",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Stok: 10",
                                  style: TextStyle(
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
                                  initialValue: "19.000",
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
      body: Column(
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
                      hintText: "Cari Produk",
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
                const SizedBox(
                  width: 15,
                ),
                const Expanded(
                  flex: -1,
                  child: Image(image: AssetImage("assets/images/barcode.png")),
                ),
                const SizedBox(
                  width: 15,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(
                      top: 5, bottom: 15, left: 20, right: 20),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Image(
                          image: AssetImage(
                            "assets/images/default-product.png",
                          ),
                          height: 70,
                          width: 70,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Aqua Galon",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "898982385632",
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              "Harga dasar: Rp. 5000",
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        flex: -1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "Stok: 10",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              "Rp. 7.000",
                              style: TextStyle(fontSize: 13),
                            ),
                            GestureDetector(
                                onTap: () async {
                                  await showEditingFormDialog(context);
                                },
                                child: const Icon(Icons.edit_square))
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
