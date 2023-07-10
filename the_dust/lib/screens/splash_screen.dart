import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:the_dust/calc/gps2grid.dart';
import 'package:the_dust/calc/pm10color.dart';
import 'package:the_dust/const/data/data.dart';
import 'package:the_dust/layouts/default_layout.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:the_dust/models/gps2tm.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:the_dust/models/tm2near.dart';
import 'package:the_dust/screens/home_screen.dart';
import 'package:the_dust/utils/air_condition_notifier.dart';
// import 'package:geolocator/geolocator.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  final Dio dio = Dio();
  final storage = const FlutterSecureStorage();
  final List<String> stationNameList = [];
  final List gps = [];
  final dataBundle = {};

  @override
  void initState() {
    super.initState();
    getCurrentPosition();
    getGrid();
    getAuthToken();
  }

  Future<void> getCurrentPosition() async {
    //사용자 권환 획득 (높은 정확도)
    LocationPermission permission = await Geolocator.requestPermission();
    //현재 사용자의 위치 GPS 값 받아오기 (높은 정확도)
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final latitude = position.latitude;
    final longitude = position.longitude;
    //저장
    await storage.write(key: LAT, value: latitude.toString());
    await storage.write(key: LNG, value: longitude.toString());
  }

  // HomeScreen 에 넘겨줄 기온
  Future<void> getGrid() async {
    final lat = await storage.read(key: LAT);
    final lng = await storage.read(key: LNG);
    final int xgrid =
        Gps2Grid.gpsToGRID(double.parse(lat!), double.parse(lng!))['x'];

    final int ygrid =
        Gps2Grid.gpsToGRID(double.parse(lat), double.parse(lng))['y'];
    dataBundle['xgrid'] = xgrid;
    dataBundle['ygrid'] = ygrid;
    //기상청용 그리드 좌표 변환
  }

  //SGIS AuthToken -> GPS 를 TM 좌표값으로 변환 -> 근첩 측정소 조회 -> 해당 측정소로 대기정보 요청
  //SGIS 인증토큰 발급
  Future<void> getAuthToken() async {
    final Gps2Tm tm;
    tm = Gps2Tm(dio);
    await tm
        .getAuthToken(
            key: "d7fb11be307f45dcbaa6", secret: "56b1d86baff049ae866a")
        .then((value) async {
      await storage.write(key: accessToken, value: value.result['accessToken']);
      //GPS 를 TM 좌표값으로 변환
      final lat = await storage.read(key: LAT);
      final lng = await storage.read(key: LNG);
      final res = tm.getTm(
          dst: 5181,
          accessToken: value.result['accessToken'],
          posX: double.parse(lng!),
          posY: double.parse(lat!));
      return res;
    }).then((value) async {
      // print(value.result);
      final Tm2NearStation station;
      station = Tm2NearStation(dio);

      final tmX = value.result['posX'];
      final tmY = value.result['posY'];
      final res = station.getNearStation(tmX: tmX!, tmY: tmY!);
      return res;
    }).then((value) async {
      //관측소 이름 리스트

      final List<dynamic> airConditionList = [];
      final Tm2NearStation condition;
      condition = Tm2NearStation(dio);
      for (int i = 0; i < value.response['body']['items'].length; i++) {
        stationNameList.add(
          value.response['body']['items'][i]['stationName'],
        );
        final res = await condition.getAirCondition(
            stationName: value.response['body']['items'][i]['stationName']);
        airConditionList.add(res.response['body']['items']);
      }
      // //홈으로 넘겨줄 미세먼지 측정 관측소 3곳 이름
      // dataBundle['station'] = stationNameList;
      //홈으로 넘겨줄 미세먼지 측정 데이터
      // dataBundle['airConditionList'] = airConditionList;
      return airConditionList;
    }).then((value) {
      final List<String> stationList = [];
      final List<dynamic> airDataList = [];
      final int pm10;

      if (value[0][0]['pm10Value'] == null) {
        pm10 = int.parse(value[0][1]['pm10Value']);
        stationList.add(stationNameList[1]);
      } else if (value[0][0]['pm10Value'] == null &&
          value[0][1]['pm10Value'] == null) {
        pm10 = int.parse(value[0][2]['pm10Value']);
        stationList.add(stationNameList[2]);
      } else {
        pm10 = int.parse(value[0][0]['pm10Value']);
        stationList.add(stationNameList[0]);
      }
      airDataList.add(pm10);

      final int pm25;
      if (value[0][0]['pm25Value'] == null) {
        pm25 = int.parse(value[0][1]['pm25Value']);
        stationList.add(stationNameList[1]);
      } else if (value[0][0]['pm25Value'] == null &&
          value[0][1]['pm25Value'] == null) {
        pm25 = int.parse(value[0][2]['pm25Value']);
        stationList.add(stationNameList[2]);
      } else {
        pm25 = int.parse(value[0][0]['pm25Value']);
        stationList.add(stationNameList[0]);
      }
      airDataList.add(pm25);

      final double o3;
      if (value[0][0]['o3Value'] == null) {
        o3 = double.parse(value[0][1]['o3Value']);
        stationList.add(stationNameList[1]);
      } else if (value[0][0]['o3Value'] == null &&
          value[0][1]['o3Value'] == null) {
        o3 = double.parse(value[0][2]['o3Value']);
        stationList.add(stationNameList[2]);
      } else {
        o3 = double.parse(value[0][0]['o3Value']);
        stationList.add(stationNameList[0]);
      }

      airDataList.add(o3);

      final double no2;
      if (value[0][0]['no2Value'] == null) {
        no2 = double.parse(value[0][1]['no2Value']);
        stationList.add(stationNameList[1]);
      } else if (value[0][0]['no2Value'] == null &&
          value[0][1]['no2Value'] == null) {
        no2 = double.parse(value[0][2]['no2Value']);
        stationList.add(stationNameList[2]);
      } else {
        no2 = double.parse(value[0][0]['no2Value']);
        stationList.add(stationNameList[0]);
      }
      airDataList.add(no2);

      final double so2;
      if (value[0][0]['so2Value'] == null) {
        so2 = double.parse(value[0][1]['so2Value']);
        stationList.add(stationNameList[1]);
      } else if (value[0][0]['so2Value'] == null &&
          value[0][1]['so2Value'] == null) {
        so2 = double.parse(value[0][2]['so2Value']);
        stationList.add(stationNameList[2]);
      } else {
        so2 = double.parse(value[0][0]['so2Value']);
        stationList.add(stationNameList[0]);
      }

      airDataList.add(so2);

      final double co;
      if (value[0][0]['coValue'] == null) {
        co = double.parse(value[0][1]['coValue']);
        stationList.add(stationNameList[1]);
      } else if (value[0][0]['coValue'] == null &&
          value[0][1]['coValue'] == null) {
        co = double.parse(value[0][2]['coValue']);
        stationList.add(stationNameList[2]);
      } else {
        co = double.parse(value[0][0]['coValue']);
        stationList.add(stationNameList[0]);
      }
      airDataList.add(co);
      dataBundle['data'] = airDataList;
      dataBundle['station'] = stationList;
      //PM10 미세먼지 색상
      DustColor.pm10Calc(pm10, ref);
      DustColor.pm25Calc(pm25, ref);
      DustColor.o3Calc(o3, ref);
      DustColor.no2Calc(no2, ref);
      DustColor.so2Calc(so2, ref);
      DustColor.coCalc(co, ref);
    }).then((value) async {
      await getAddress();
    }).then((value) {
      final Color bgColor = ref.watch(pm10ColorProvider);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            data: dataBundle,
            bgColor: bgColor,
          ),
        ),
      );
    });
  }

  Future<void> getAddress() async {
    final Gps2Tm tm;
    tm = Gps2Tm(dio);
    await tm
        .getAuthToken(
            key: "d7fb11be307f45dcbaa6", secret: "56b1d86baff049ae866a")
        .then((value) async {
      final token = value.result['accessToken'];
      final lat = await storage.read(key: LAT);
      final lng = await storage.read(key: LNG);

      final res = tm.getTm(
          accessToken: token,
          posX: double.parse(lng!),
          posY: double.parse(lat!),
          dst: 5179);
      return res;
    }).then((value) async {
      // print(value.result);
      final token = await storage.read(key: accessToken);
      final tmX = value.result['posX'];
      final tmY = value.result['posY'];
      final res =
          await tm.getAddress(accessToken: token!, coorX: tmX!, coorY: tmY!);
      return res;
    }).then(
      (value) {
        //홈으로 넘겨줄 사용자의 동 이름
        if (value.result[0]['emdong_nm'] == null) {
          dataBundle['userDong'] = "정보없음";
        }
        dataBundle['userSi'] = value.result[0]['sgg_nm'];
        dataBundle['userDong'] = value.result[0]['emdong_nm'];
        // print(value.result[0]['emdong_nm']);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      bgColor: Colors.black,
      child: Center(
        child: LoadingAnimationWidget.dotsTriangle(
          color: const Color.fromARGB(255, 179, 255, 0),
          size: 32,
        ),
      ),
    );
  }
}
