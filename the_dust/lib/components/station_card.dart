import 'package:flutter/material.dart';

class StationCard extends StatelessWidget {
  final String category, station;

  const StationCard({
    required this.station,
    required this.category,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          category,
          style: const TextStyle(
              color: Color.fromARGB(255, 189, 189, 189),
              fontWeight: FontWeight.w600,
              fontSize: 14),
        ),
        const SizedBox(
          height: 6,
        ),
        Text(
          station,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color.fromARGB(255, 128, 128, 128),
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }
}
