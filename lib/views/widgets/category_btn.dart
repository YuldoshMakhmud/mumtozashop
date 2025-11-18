import 'dart:convert';

import 'package:flutter/material.dart';


class CategoryBtn extends StatefulWidget {

  final String imageBase64;
  final String name;

  const CategoryBtn({super.key, required this.imageBase64, required this.name,});

  @override
  State<CategoryBtn> createState() => _CategoryBtnState();
}

class _CategoryBtnState extends State<CategoryBtn> {
  @override
  Widget build(BuildContext context) {

    final imageBytes = base64Decode(widget.imageBase64);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/show_specific_products", arguments: {"name": widget.name,});
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(4),
        height: 95,
        width: 95,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                imageBytes,
                height: 50,
                width: 50,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
