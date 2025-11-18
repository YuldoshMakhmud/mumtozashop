import 'package:flutter/material.dart';


class SegmentTitle extends StatelessWidget {
  final String titleSegment;

  const SegmentTitle({super.key, required this.titleSegment,});

  @override
  Widget build(BuildContext context) {
    return Text(
      titleSegment,
      style: TextStyle(
        fontSize: 18,
      ),
    );
  }
}
