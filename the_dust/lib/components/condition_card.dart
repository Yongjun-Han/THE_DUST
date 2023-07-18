import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConditionCard extends ConsumerWidget {
  final String data;
  final String category, condition;
  final Color colors;

  const ConditionCard({
    required this.colors,
    required this.data,
    required this.category,
    required this.condition,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data,
                style: TextStyle(
                  color: colors,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                category,
                style: TextStyle(
                  color: colors,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                condition,
                style: TextStyle(
                  color: condition == "측정소 점검중" ? Colors.amber : colors,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )
        // const SkeletonAvatar(
        //   style: SkeletonAvatarStyle(
        //     shape: BoxShape.rectangle,
        //     width: 100,
        //     height: 100,
        //   ),
        // ),
        );
  }
}
