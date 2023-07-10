import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_dust/color/colors.dart';
import 'package:the_dust/utils/air_color_model.dart';

class AirStatusListNotifier extends StateNotifier<List<AirStatusrModel>> {
  AirStatusListNotifier()
      : super(
          [
            AirStatusrModel(
              nameKo: "미세먼지",
              nameEn: "pm10Value",
              color: GOOD,
              status: "좋음",
              level: 1,
              isMain: false,
            ),
            AirStatusrModel(
              nameKo: "초미세먼지",
              nameEn: "pm10Value",
              color: GOOD,
              status: "좋음",
              level: 1,
              isMain: false,
            ),
            AirStatusrModel(
              nameKo: "오존",
              nameEn: "o3Value",
              color: GOOD,
              status: "좋음",
              level: 1,
              isMain: false,
            ),
            AirStatusrModel(
              nameKo: "이산화질소",
              nameEn: "no2Value",
              color: GOOD,
              status: "좋음",
              level: 1,
              isMain: false,
            ),
            AirStatusrModel(
              nameKo: "아황산가스",
              nameEn: "so2Value",
              color: GOOD,
              status: "좋음",
              level: 1,
              isMain: false,
            ),
            AirStatusrModel(
              nameKo: "일산화탄소",
              nameEn: "coValue",
              color: GOOD,
              status: "좋음",
              level: 1,
              isMain: false,
            ),
          ],
        );

  void calcPm10({
    required String nameEn,
    required List data,
  }) {
    if (nameEn == "pm10Value" && data[0][0]['pm10Value'] <= 30) {
      state = state
          .map((e) => e.nameEn == nameEn
              ? AirStatusrModel(
                  nameKo: e.nameKo,
                  nameEn: e.nameEn,
                  color: e.color,
                  status: e.status,
                  level: e.level,
                  isMain: e.isMain,
                )
              : e)
          .toList();
    }

    // if (e.nameEn == nameEn && data[0][0]['pm10Value'] <= 30) {
    // } else if (pm10level > 30 && pm10level <= 48) {
    // } else if (pm10level > 48 && pm10level <= 65) {
    // } else if (pm10level > 65 && pm10level <= 99) {
    // } else if (pm10level > 99 && pm10level <= 150) {
    // } else if (pm10level > 150) {}
  }
}
