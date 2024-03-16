import 'package:flutter/material.dart';

class Struk extends StatelessWidget {
  const Struk({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff076A68).withOpacity(0.3),
        leading: Container(
          height: 40,
          width: 45,
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Color(0xff076A68),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Container(
        color: const Color(0xff076A68).withOpacity(0.3),
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            padding: const EdgeInsets.all(30),
            height: 540,
            width: 321,
            child: Column(
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Toko Nay',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text('Ds. Muncang'),
                const SizedBox(
                  height: 17,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('2024-02-08'),
                    Spacer(),
                    Text('mr Anto'),
                  ],
                ),
                const Row(
                  children: [Text('13:03:12'), Spacer()],
                ),
                const Text(
                  "------------------------------",
                  style: TextStyle(fontSize: 30),
                ),
                ...createReceiptItems(),
                const Text(
                  "------------------------------",
                  style: TextStyle(fontSize: 30),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal'),
                    Text('Rp. 5.000'),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Rp. 54.000',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Bayar (Cash)'),
                    Text('Rp. 54.000'),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Kembali'),
                    Text('Rp. 0'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> createReceiptItems() {
    return [
      createReceiptItem('Sabun Lifebuoy', 3000, 1, 3000),
      createReceiptItem('Shampo Clear', 1000, 1, 1000),
      createReceiptItem('Shampo Clear', 1000, 1, 1000),
    ];
  }

  Widget createReceiptItem(
      String name, int price, int quantity, int totalPrice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name),
              Text('$quantity x $price'),
            ],
          ),
        ),
        Text('Rp. $totalPrice'),
      ],
    );
  }
}
