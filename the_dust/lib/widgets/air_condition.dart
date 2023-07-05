import 'package:flutter/material.dart';
import 'package:the_dust/components/condition_card.dart';

class AirCondition extends StatelessWidget {
  const AirCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "대기질 정보",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                return const Row(
                  children: [
                    ConditionCard(data: 17, category: "미세먼지", condition: "좋음")
                  ],
                );
              },
              separatorBuilder: (_, index) {
                return const SizedBox(
                  width: 12,
                );
              },
              itemCount: 6,
            ),
          ),
        ],
      ),
    );
  }
}
