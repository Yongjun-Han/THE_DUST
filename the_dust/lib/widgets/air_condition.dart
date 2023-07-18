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

    final pm10Color = ref.watch(pm10ColorProvider);
    final pm25Color = ref.watch(pm25ColorProvider);
    final o3Color = ref.watch(o3ColorProvider);
    final no2Color = ref.watch(no2ColorProvider);
    final so2Color = ref.watch(so2ColorProvider);
    final coColor = ref.watch(coColorProvider);

    late List arr = [
      pm10State,
      pm25State,
      o3State,
      no2State,
      so2State,
      coState,
    ];

    final List colorArr = [
      pm10Color,
      pm25Color,
      o3Color,
      no2Color,
      so2Color,
      coColor,
    ];
    // print(station);

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
                      colors: colorArr[index],
                      data: (data[index]).toString(),
                      category: airCategoryKo[index],
                      condition: arr[index],
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
