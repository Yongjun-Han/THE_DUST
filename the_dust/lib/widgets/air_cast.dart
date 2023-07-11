import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:the_dust/components/cast_card.dart';
import 'package:the_dust/models/tm2near.dart';

class AirCast extends StatelessWidget {
  const AirCast({super.key});

  Future<Map<String, dynamic>> getCastInfo() async {
    final Map<String, dynamic> returnData = {};
    final Dio dio = Dio();
    final DateTime dt = DateTime.now();
    final String today;
    if (dt.month < 10) {
      today = "${dt.year}-0${dt.month}-${dt.day}";
    } else {
      today = "${dt.year}-${dt.month}-${dt.day}";
    }
    final Tm2NearStation cast;
    cast = Tm2NearStation(dio);
    final res = cast.getCast(searchDate: today).then((value) {
      returnData['castTimeToday'] =
          value.response['body']['items'][0]['dataTime'];
      returnData['castMsgToday'] =
          value.response['body']['items'][0]['informCause'];
      returnData['castTimeTomorrow'] =
          value.response['body']['items'][1]['dataTime'];
      returnData['castMsgTomorrow'] =
          value.response['body']['items'][1]['informCause'];
      return returnData;
    }).then((value) => value);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    getCastInfo();
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: FutureBuilder(
            future: getCastInfo(),
            builder: (context, snapshot) {
              final item = snapshot.data;
              print(item);
              if (!snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "미세먼지 예보",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "데이터를 가져오고 있어요",
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.black26),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const CastCard(
                      title: "오늘",
                      message: "데이터를 가져오고 있어요",
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const CastCard(
                      title: "내일",
                      message: "데이터를 가져오는 중입니다",
                    ),
                  ],
                );
              } else {}
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "미세먼지 예보",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          item!['castTimeToday'],
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.black26),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CastCard(
                    title: "오늘",
                    message: item['castMsgToday']
                        .toString()
                        .replaceAll("○ [미세먼지] ", ""),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CastCard(
                    title: "내일",
                    message: item['castMsgTomorrow']
                        .toString()
                        .replaceAll("○ [미세먼지] ", ""),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
