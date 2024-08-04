import 'package:flutter/material.dart';

class ConfirmTransaction extends StatefulWidget {
  const ConfirmTransaction(
      {super.key,
      required this.index,
      required this.name,
      required this.price,
      required this.count});

  final int index;
  final String name;
  final String price;
  final int count;

  @override
  State<ConfirmTransaction> createState() => _ConfirmTransaction();
}

class _ConfirmTransaction extends State<ConfirmTransaction> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: -1,
                child: Text(
                  widget.index.toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
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
                          widget.count.toString(),
                          style: const TextStyle(fontSize: 10),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          child: const Text("x"),
                        ),
                        Text(widget.price, style: const TextStyle(fontSize: 10))
                      ],
                    )
                  ],
                ),
              ),
              const Icon(
                Icons.delete,
                color: Color(0xffFF0000),
              )
            ],
          )
        ],
      ),
    );
  }
}
