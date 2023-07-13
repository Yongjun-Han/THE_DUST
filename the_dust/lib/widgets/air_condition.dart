import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_dust/const/color/colors.dart';
import 'package:the_dust/components/condition_card.dart';
import 'package:the_dust/components/station_card.dart';
import 'package:the_dust/const/data/data.dart';
import 'package:the_dust/utils/air_condition_notifier.dart';

class AirCondition extends ConsumerWidget {
  final List<dynamic> station;
  final List<dynamic> data;

  const AirCondition({
    required this.station,
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pm10State = ref.watch(pm10MessageProvider);
    final pm25State = ref.watch(pm25MessageProvider);
    final no2State = ref.watch(no2MessageProvider);
    final so2State = ref.watch(so2MessageProvider);
    final coState = ref.watch(coMessageProvider);

    final pm10Color = ref.watch(pm10ColorProvider);
    final pm25Color = ref.watch(pm25ColorProvider);
    final no2Color = ref.watch(no2ColorProvider);
    final so2Color = ref.watch(so2ColorProvider);
    final coColor = ref.watch(coColorProvider);

    late String o3State;
    late Color o3Color;
    if (data[2] <= 0.030) {
      o3State = "좋음";
      o3Color = GOOD;
    } else if (data[2] > 0.030 && data[2] <= 0.060) {
      o3State = "양호";
      o3Color = NICE;
    } else if (data[2] > 0.060 && data[2] <= 0.090) {
      o3State = "보통";
      o3Color = MODERATE;
    } else if (data[2] > 0.090 && data[2] <= 0.200) {
      o3State = "나쁨";
      o3Color = UNHEALTHY;
    } else if (data[2] > 0.200 && data[2] <= 0.380) {
      o3State = "상당히나쁨";
      o3Color = VERY_UNHEALTHY;
    } else if (data[2] > 0.380) {
      o3State = "매우나쁨";
      o3Color = HAZARDOUS;
    } else {
      o3State = "";
      o3Color = Colors.white;
    }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "대기질 정보",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  modal(context);
                  // print(station);
                },
                child: const Icon(Icons.info_outline),
              )
            ],
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

  Future<dynamic> modal(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: BASIC_MODAL,
      context: context,
      builder: (BuildContext context) {
        final List<String> category = [
          "미세먼지",
          "초미세먼지",
          "오존",
          "이산화질소",
          "아황산가스",
          "일산화탄소",
        ];
        return SizedBox(
          height: 400,
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xff5B5B5B),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )
                  ]),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    "대기질 측정소 세부 정보",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Column(
                    children: [
                      StationCard(
                        station: station[0],
                        category: category[0],
                      ),
                      StationCard(
                        station: station[1],
                        category: category[1],
                      ),
                      StationCard(
                        station: station[2],
                        category: category[2],
                      ),
                      StationCard(
                        station: station[3],
                        category: category[3],
                      ),
                      StationCard(
                        station: station[4],
                        category: category[4],
                      ),
                      StationCard(
                        station: station[5],
                        category: category[5],
                      ),
                    ],
                  )
                ],
              )),
        );
      },
    );
  }
}
