import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_dust/color/colors.dart';

//미세먼지 수치  배경색용
final pm10ColorProvider = StateProvider<Color>((ref) => GOOD);
//미세먼지 수치 문구
final pm10MessageProvider = StateProvider<String>((ref) => "좋음");
//미세먼지 수치 레벨
final pm10LevelProvider = StateProvider<int>((ref) => 1);
//미세먼지 수치에 따른 이모지용

//초미세먼지 수치  배경색용
final pm25ColorProvider = StateProvider<Color>((ref) => GOOD);
//초미세먼지 수치 문구
final pm25MessageProvider = StateProvider<String>((ref) => "좋음");
//초미세먼지 수치 레벨
final pm25LevelProvider = StateProvider<int>((ref) => 1);

//오존 수치  배경색용
final o3ColorProvider = StateProvider<Color>((ref) => GOOD);
//오존 수치 문구
final o3MessageProvider = StateProvider<String>((ref) => "좋음");

//이산화질소 수치  배경색용
final no2ColorProvider = StateProvider<Color>((ref) => GOOD);
//이산화질소 수치 문구
final no2MessageProvider = StateProvider<String>((ref) => "좋음");

//아황산가스 수치  배경색용
final so2ColorProvider = StateProvider<Color>((ref) => GOOD);
//아황산가스 수치 문구
final so2MessageProvider = StateProvider<String>((ref) => "좋음");

//일산화탄소 수치  배경색용
final coColorProvider = StateProvider<Color>((ref) => GOOD);
//일산화탄소 수치 문구
final coMessageProvider = StateProvider<String>((ref) => "좋음");

final emojiProvider =
    StateProvider<String>((ref) => "lib/assets/image/GOOD.png");
