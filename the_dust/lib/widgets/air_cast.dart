import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:the_dust/common/dio/dio.dart';
import 'package:the_dust/components/cast_card.dart';
import 'package:the_dust/const/data/data.dart';
import 'package:the_dust/models/tm2near.dart';
import 'package:the_dust/utils/air_condition_notifier.dart';

class AirCast extends ConsumerStatefulWidget {
  const AirCast({super.key});

  @override
  ConsumerState<AirCast> createState() => _AirCastState();
}

class _AirCastState extends ConsumerState<AirCast> {
  Future<Map<String, dynamic>> getCastInfo(WidgetRef ref) async {
    final Map<String, dynamic> returnData = {};
    const storage = FlutterSecureStorage();
    final Dio dio = Dio();
    dio.interceptors.add(CustomInterceptor());
    final DateTime dt = DateTime.now();
    final String today;
    if (dt.month < 10) {
      today = "${dt.year}-0${dt.month}-${dt.day}";
    } else {
      today = "${dt.year}-${dt.month}-${dt.day}";
    }
    final Tm2NearStation cast;
    cast = Tm2NearStation(dio);

    final res = await cast.getCast(searchDate: today).then((value) async {
      if (value.response['body'] == null) {
        ref.read(isGetCastProvider.notifier).update((state) => false);
        return {
          "castTimeToday": "데이터응답에 실패했어요",
          'castMsgToday': "데이터응답에 실패했어요",
          'castTimeTomorrow': "데이터응답에 실패했어요",
          'castMsgTomorrow': "데이터응답에 실패했어요",
        };
      } else {
        returnData['castTimeToday'] =
            value.response['body']['items'][0]['dataTime'];
        returnData['castMsgToday'] =
            value.response['body']['items'][0]['informCause'];
        returnData['castTimeTomorrow'] =
            value.response['body']['items'][1]['dataTime'];
        returnData['castMsgTomorrow'] =
            value.response['body']['items'][1]['informCause'];
        await storage.write(key: CASTDATA, value: jsonEncode(returnData));
        return returnData;
      }
    });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: FutureBuilder(
            future: getCastInfo(ref),
            builder: (context, snapshot) {
              final item = snapshot.data;
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
                      message: "데이터를 가져오고 있어요",
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
