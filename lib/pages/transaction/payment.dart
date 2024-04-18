import 'package:flutter/material.dart';
import 'package:kasir_mobile/pages/transaction/payment_done.dart';
import 'package:kasir_mobile/provider/post_transaction.dart';

class Payment extends StatefulWidget {
  const Payment(
      {super.key, required this.totalPrice, required this.listTransaction});

  final dynamic listTransaction;
  final int totalPrice;

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  String nominal = "0";

  @override
  void initState() {
    super.initState();
  }

  postTransaction() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff076A68),
        title: Text(
          "Rp. ${widget.totalPrice}",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 60),
              child: Text(
                "Rp. $nominal",
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            const Divider(),
            const SizedBox(height: 16.0),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              children: List.generate(9, (index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (nominal == "0") {
                        nominal = "";
                      }
                      nominal = (nominal + (index + 1).toString());
                    });
                  },
                  child: Center(
                    child: Text(
                      (index + 1).toString(),
                      style: const TextStyle(fontSize: 20.0),
                    ),
                  ),
                );
              }),
            ),
            // Tambahan dua grid
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                if (index == 2) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        nominal = "0";
                      });
                    },
                    child: const Center(
                      child: Text(
                        'C',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  );
                } else if (index == 0) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        nominal = '${nominal}0';
                      });
                    },
                    child: const Center(
                      child: Text(
                        '0',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  );
                } else {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        nominal = "${nominal}000";
                      });
                    },
                    child: const Center(
                      child: Text(
                        '000',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16.0),

            Container(
              width: 330,
              decoration: const BoxDecoration(
                  color: Color(0xffFFCA45),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: TextButton(
                onPressed: () async {
                  if (int.parse(nominal) < widget.totalPrice) {
                    const snackBar = SnackBar(
                      duration: Duration(seconds: 5),
                      content:
                          Text("Nominal tidak boleh kurang dari total harga"),
                      backgroundColor: Colors.red,
                    );

                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }

                  List<RequestTransaction> transaction = [];

                  List<Map<String, dynamic>> groupedTransaction =
                      widget.listTransaction.values.toList();

                  int totalPayment = 0;
                  int change = int.parse(nominal) - widget.totalPrice;

                  for (var item in groupedTransaction) {
                    totalPayment = totalPayment +
                        ((item['price'] as num).toInt() *
                            (item['count'] as num).toInt());
                    RequestTransaction requestTransaction = RequestTransaction(
                        idProduct: item['id'],
                        name: item['name'],
                        itemPrice: item['price'],
                        quantity: item['count']);
                    transaction.add(requestTransaction);
                  }

                  var postTransaction = await PostTransaction.post(
                      double.parse(nominal), transaction);
                  if (postTransaction['status'] == true) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentDone(
                                  change: change,
                                )));
                  } else {
                    var snackBar = SnackBar(
                      duration: const Duration(seconds: 5),
                      content: Text(postTransaction['message'].toString()),
                      backgroundColor: Colors.red,
                    );

                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }
                },
                child: const Text(
                  'BAYAR',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
