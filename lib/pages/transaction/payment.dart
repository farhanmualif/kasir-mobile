import 'package:flutter/material.dart';
import 'package:kasir_mobile/pages/transaction/payment_done.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  int _selectedIndex = 0;

  String nominal = "0";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff076A68),
        title: const Text(
          "Transaksi",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 60),
              child: Text(
                "Rp. $nominal",
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Spacer(),
            Row(
              children: [
                Checkbox(
                  value: _selectedIndex == 1,
                  onChanged: (value) {
                    setState(() {
                      _selectedIndex = value! ? 1 : 0;
                    });
                  },
                ),
                const Text('Tandai Sebagai Piutang'),
              ],
            ),
            const SizedBox(height: 16.0),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              children: List.generate(9, (index) {
                return Center(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (nominal == "0") {
                          nominal = "";
                        }
                        nominal = (nominal + (index + 1).toString());
                      });
                    },
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
                        style: const TextStyle(fontSize: 20.0),
                      ),
                    ),
                  );
                } else if (index == 0) {
                  return InkWell(
                    onTap: () {
                      // Add your onPress logic here for resetting nominal
                    },
                    child: const Center(
                      child: Text(
                        '0',
                        style: const TextStyle(fontSize: 20.0),
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
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PaymentDone()));
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
