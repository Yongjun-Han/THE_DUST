import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_dust/components/condition_card.dart';
import 'package:the_dust/const/data/data.dart';
import 'package:the_dust/utils/air_condition_notifier.dart';

class AirCondition extends ConsumerWidget {
  final List<dynamic> data;

  const AirCondition({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pm10State = ref.watch(pm10MessageProvider);
    final pm25State = ref.watch(pm25MessageProvider);
    final o3State = ref.watch(o3MessageProvider);
    final no2State = ref.watch(no2MessageProvider);
    final so2State = ref.watch(so2MessageProvider);
    final coState = ref.watch(coMessageProvider);

    final List airStateList = [
      pm10State,
      pm25State,
      o3State,
      no2State,
      so2State,
      coState
    ];

    print(airStateList);

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
                return Row(
                  children: [
                    ConditionCard(
                      data: (data[index]).toString(),
                      category: airCategoryKo[index],
                      condition: airStateList[index],
                    )
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
