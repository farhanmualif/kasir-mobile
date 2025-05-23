// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ListTransaction extends StatefulWidget {
  ListTransaction({
    super.key,
    required this.name,
    required this.price,
    required this.remaining,
    this.count = 0,
  });

  final String name;
  final String price;
  final String remaining;
  int count = 0;

  @override
  // ignore: library_private_types_in_public_api
  _ListTransactionState createState() => _ListTransactionState();
}

class _ListTransactionState extends State<ListTransaction> {
  @override
  Widget build(BuildContext context) {
    return listTransactionComponent();
  }

  listTransactionComponent() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: -1,
              child: Container(
                margin: const EdgeInsets.all(5),
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    image: DecorationImage(
                        image: AssetImage("assets/images/image.png"))),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Row(
                    children: [
                      Text(
                        widget.remaining,
                        style: const TextStyle(fontSize: 10),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5, right: 5),
                        child: const Icon(
                          Icons.do_not_disturb_on_sharp,
                          size: 10,
                        ),
                      ),
                      Text("Rp.${widget.price}",
                          style: const TextStyle(fontSize: 10))
                    ],
                  )
                ],
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (widget.count != 0) {
                        widget.count--;
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    height: 35,
                    width: 25,
                    decoration: const BoxDecoration(
                        color: Color(0xffE0EBFF),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: const Icon(Icons.minimize),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  height: 35,
                  width: 20,
                  decoration: const BoxDecoration(
                      color: Color(0xffE0EBFF),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Center(child: Text(widget.count.toString())),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.count++;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    height: 35,
                    width: 25,
                    decoration: const BoxDecoration(
                        color: Color(0xffE0EBFF),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
