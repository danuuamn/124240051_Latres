import 'package:flutter/material.dart';

class StatusText extends StatelessWidget {
  const StatusText({super.key, required this.status});

  final String status;

  Color get _color {
    if (status == 'Alive') return Colors.green;
    if (status == 'Dead') return Colors.red;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(status == 'unknown' ? 'Unknown' : status),
      ],
    );
  }
}
