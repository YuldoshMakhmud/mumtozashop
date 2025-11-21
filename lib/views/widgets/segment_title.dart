import 'package:flutter/material.dart';

class SegmentTitle extends StatelessWidget {
  final String titleSegment;
  final Color color;

  const SegmentTitle({
    super.key,
    required this.titleSegment,
    this.color = Colors.pinkAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Text(titleSegment, style: TextStyle(fontSize: 18, color: color));
  }
}
