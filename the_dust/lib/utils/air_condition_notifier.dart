import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_dust/color/colors.dart';
import 'package:the_dust/utils/air_color_model.dart';

//미세먼지 수치에 따른 배경색용
final pm10ColorProvider = StateProvider<Color>((ref) => GOOD);
//미세먼지 수치에 따른 배경색용
final dustMessageProvider = StateProvider<String>((ref) => "좋음");
//미세먼지 수치에 따른 이모지용
final emojiProvider =
    StateProvider<String>((ref) => "lib/assets/image/GOOD.png");

final airColorProvider =
    StateNotifierProvider<AirColorNotifier, List<AirColorModel>>(
        (ref) => AirColorNotifier());

class AirColorNotifier extends StateNotifier<List<AirColorModel>> {
  AirColorNotifier()
      : super([
          AirColorModel(
            level: 1,
            color: const Color(0xff5682C3),
            isSelected: true,
          ),
          AirColorModel(
            level: 2,
            color: const Color(0xff45966A),
            isSelected: false,
          ),
          AirColorModel(
            level: 3,
            color: const Color(0xffFAE665),
            isSelected: false,
          ),
          AirColorModel(
            level: 4,
            color: const Color(0xffF28434),
            isSelected: false,
          ),
          AirColorModel(
            level: 5,
            color: const Color(0xffB15437),
            isSelected: false,
          ),
          AirColorModel(
            level: 6,
            color: const Color(0xff892828),
            isSelected: false,
          ),
        ]);

  void isSelected({
    required Color color,
  }) {
    state = state
        .map(
          (e) => e.color == color
              ? AirColorModel(
                  level: e.level,
                  color: e.color,
                  isSelected: !e.isSelected,
                )
              : AirColorModel(
                  level: e.level,
                  color: e.color,
                  isSelected: false,
                ),
        )
        .toList();
  }
}

// final List<String> category = [
//   '식음료',
//   '숙박',
//   '관광지',
//   '체험',
//   '동물병원',
// ];
