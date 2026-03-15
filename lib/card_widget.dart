import 'dart:async';
import 'package:flutter/material.dart';

class BillCard extends StatefulWidget {
  final Map data;

  const BillCard(this.data, {super.key});

  @override
  State<BillCard> createState() => _BillCardState();
}

class _BillCardState extends State<BillCard> {
  int index = 0;
  List<String> texts = [];

  @override
  void initState() {
    super.initState();

    final body = widget.data["template_properties"]["body"];

    if (body["flipper_config"] != null) {
      for (var item in body["flipper_config"]["items"]) {
        texts.add(item["text"]);
      }

      Timer.periodic(const Duration(seconds: 2), (timer) {
        setState(() {
          index = (index + 1) % texts.length;
        });
      });
    } else {
      texts.add(body["footer_text"] ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = widget.data["template_properties"]["body"];

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              body["title"] ?? "",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(body["sub_title"] ?? ""),

            const Spacer(),

            Text(
              body["payment_amount"] ?? "",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(texts[index], style: const TextStyle(color: Colors.green)),
          ],
        ),
      ),
    );
  }
}
