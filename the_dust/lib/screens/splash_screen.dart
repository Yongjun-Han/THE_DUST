import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:the_dust/calc/gps2grid.dart';
import 'package:the_dust/calc/airCalc.dart';
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
    // getAuthToken();
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

  // HomeScreen 에 넘겨줄 dataBundle 속 기온데이터 요청에 필요한 그리드좌표 획득
  Future<void> getGrid() async {
    //앞서 저장한 사용자 좌표값 조회
    final lat = await storage.read(key: LAT);
    final lng = await storage.read(key: LNG);
    //기상청용 그리드 좌표 변환
    final int xgrid =
        Gps2Grid.gpsToGRID(double.parse(lat!), double.parse(lng!))['x'];
    final int ygrid =
        Gps2Grid.gpsToGRID(double.parse(lat), double.parse(lng))['y'];
    //dataBundle에 넣어준다
    dataBundle['xgrid'] = xgrid;
    dataBundle['ygrid'] = ygrid;
  }

  //SGIS AuthToken -> GPS 를 TM 좌표값으로 변환 -> 근첩 측정소 조회 -> 해당 측정소로 대기정보 요청
  Future<void> getAuthToken() async {
    final Dio dio = Dio();
    // dio.interceptors.add(CustomInterceptor());
    final Gps2Tm sgis;
    sgis = Gps2Tm(dio);
    //SGIS 인증토큰 발급
    await sgis
        .getAuthToken(
            key: "d7fb11be307f45dcbaa6", secret: "56b1d86baff049ae866a")
        .then((value) async {
      await storage.write(key: accessToken, value: value.result['accessToken']);
      //GPS 를 TM 좌표값으로 변환
      final lat = await storage.read(key: LAT);
      final lng = await storage.read(key: LNG);
      final res = sgis.getTm(
          dst: 5181,
          accessToken: value.result['accessToken'],
          posX: double.parse(lng!),
          posY: double.parse(lat!));
      return res;
    }).then((value) async {
      final Tm2NearStation station;
      station = Tm2NearStation(dio);
      //변환한 TM 좌표로 근첩측정소 조회
      final tmX = value.result['posX'];
      final tmY = value.result['posY'];
      final res = station.getNearStation(tmX: tmX!, tmY: tmY!);
      return res;
    }).then((value) async {
      //관측소 데이터 넣을 리스트
      final List<dynamic> airConditionList = [];
      final Tm2NearStation condition;
      condition = Tm2NearStation(dio);
      for (int i = 0; i < value.response['body']['items'].length; i++) {
        //관측소 이름 리스트에 담기
        stationNameList.add(
          value.response['body']['items'][i]['addr'],
        );
        final res = await condition.getAirCondition(
            stationName: value.response['body']['items'][i]['stationName']);
        airConditionList.add(res.response['body']['items']);
      }
      //3곳의 관측데이터를 리스트에 담은 후 반환
      return airConditionList;
    }).then((value) {
      //home에 넘겨줄 각 항목별 측정소 주소 리스트
      final List<String> stationList = [];
      //home에 넘겨줄 각 항목별 측정 데이터
      final List<dynamic> airDataList = [];

      //pm10 미세먼지 : 측정소 3곳중 작동하지 않거나 미수신 되는 경우 다음으로 가까운 측정소의 데이터를 요청
      final int pm10;

      //1번이 오류 2번이 오류 아닐시
      if (value[0][0]['pm10Value'] == "-" && value[0][1]['pm10Value'] != "-") {
        pm10 = int.parse(value[0][1]['pm10Value']);
        stationList.add(stationNameList[1]);
      } // 1번 2번 모두 오류시
      else if (value[0][0]['pm10Value'] == "-" &&
          value[0][1]['pm10Value'] == "-" &&
          value[0][2]['pm10Value'] != "-") {
        pm10 = int.parse(value[0][2]['pm10Value']);
        stationList.add(stationNameList[2]);
      } //1번 2번 3번 모두 오류시
      else if (value[0][0]['pm10Value'] == "-" &&
          value[0][1]['pm10Value'] == "-" &&
          value[0][2]['pm10Value'] == "-") {
        pm10 = 0;
        stationList.add("측정소 점검중");
      } // 1번이 정상일때
      else {
        pm10 = int.parse(value[0][0]['pm10Value']);
        stationList.add(stationNameList[0]);
      }
      airDataList.add(pm10);

      //pm25 초미세먼지 : 측정소 3곳중 작동하지 않거나 미수신 되는 경우 다음으로 가까운 측정소의 데이터를 요청
      final int pm25;
      //1번이 오류 2번이 오류 아닐시
      if (value[0][0]['pm25Value'] == "-" && value[0][1]['pm25Value'] != "-") {
        pm25 = int.parse(value[0][1]['pm25Value']);
        stationList.add(stationNameList[1]);
      } // 1번 2번 모두 오류시
      else if (value[0][0]['pm25Value'] == "-" &&
          value[0][1]['pm25Value'] == "-" &&
          value[0][2]['pm25Value'] != "-") {
        pm25 = int.parse(value[0][2]['pm25Value']);
        stationList.add(stationNameList[2]);
      } //1번 2번 3번 모두 오류시
      else if (value[0][0]['pm25Value'] == "-" &&
          value[0][1]['pm25Value'] == "-" &&
          value[0][2]['pm25Value'] == "-") {
        pm25 = 0;
        stationList.add("측정소 점검중");
      } // 1번이 정상일때
      else {
        pm25 = int.parse(value[0][0]['pm25Value']);
        stationList.add(stationNameList[0]);
      }
      airDataList.add(pm25);

      //o3 오존 : 측정소 3곳중 작동하지 않거나 미수신 되는 경우 다음으로 가까운 측정소의 데이터를 요청
      final double o3;
      //1번이 오류 2번이 오류 아닐시
      if (value[0][0]['o3Value'] == "-" && value[0][1]['o3Value'] != "-") {
        o3 = double.parse(value[0][1]['o3Value']);
        stationList.add(stationNameList[1]);
      } // 1번 2번 모두 오류시
      else if (value[0][0]['o3Value'] == "-" &&
          value[0][1]['o3Value'] == "-" &&
          value[0][2]['o3Value'] != "-") {
        o3 = double.parse(value[0][2]['o3Value']);
        stationList.add(stationNameList[2]);
      } //1번 2번 3번 모두 오류시
      else if (value[0][0]['o3Value'] == "-" &&
          value[0][1]['o3Value'] == "-" &&
          value[0][2]['o3Value'] == "-") {
        o3 = 0;
        stationList.add("측정소 점검중");
      } // 1번이 정상일때
      else {
        o3 = double.parse(value[0][0]['o3Value']);
        stationList.add(stationNameList[0]);
      }
      airDataList.add(o3);

      //no2 이산화질소 : 측정소 3곳중 작동하지 않거나 미수신 되는 경우 다음으로 가까운 측정소의 데이터를 요청
      final double no2;
      //1번이 오류 2번이 오류 아닐시
      if (value[0][0]['no2Value'] == "-" && value[0][1]['no2Value'] != "-") {
        no2 = double.parse(value[0][1]['no2Value']);
        stationList.add(stationNameList[1]);
      } // 1번 2번 모두 오류시
      else if (value[0][0]['no2Value'] == "-" &&
          value[0][1]['no2Value'] == "-" &&
          value[0][2]['no2Value'] != "-") {
        no2 = double.parse(value[0][2]['no2Value']);
        stationList.add(stationNameList[2]);
      } //1번 2번 3번 모두 오류시
      else if (value[0][0]['no2Value'] == "-" &&
          value[0][1]['no2Value'] == "-" &&
          value[0][2]['no2Value'] == "-") {
        no2 = 0;
        stationList.add("측정소 점검중");
      } // 1번이 정상일때
      else {
        no2 = double.parse(value[0][0]['no2Value']);
        stationList.add(stationNameList[0]);
      }
      airDataList.add(no2);

      //so2 아황산가스 : 측정소 3곳중 작동하지 않거나 미수신 되는 경우 다음으로 가까운 측정소의 데이터를 요청
      final double so2;
      //1번이 오류 2번이 오류 아닐시
      if (value[0][0]['so2Value'] == "-" && value[0][1]['so2Value'] != "-") {
        so2 = double.parse(value[0][1]['so2Value']);
        stationList.add(stationNameList[1]);
      } // 1번 2번 모두 오류시
      else if (value[0][0]['so2Value'] == "-" &&
          value[0][1]['so2Value'] == "-" &&
          value[0][2]['so2Value'] != "-") {
        so2 = double.parse(value[0][2]['so2Value']);
        stationList.add(stationNameList[2]);
      } //1번 2번 3번 모두 오류시
      else if (value[0][0]['so2Value'] == "-" &&
          value[0][1]['so2Value'] == "-" &&
          value[0][2]['so2Value'] == "-") {
        so2 = 0;
        stationList.add("측정소 점검중");
      } // 1번이 정상일때
      else {
        so2 = double.parse(value[0][0]['so2Value']);
        stationList.add(stationNameList[0]);
      }
      airDataList.add(so2);

      //co 일산화탄소 : 측정소 3곳중 작동하지 않거나 미수신 되는 경우 다음으로 가까운 측정소의 데이터를 요청
      final double co;
      //1번이 오류 2번이 오류 아닐시
      if (value[0][0]['coValue'] == "-" && value[0][1]['coValue'] != "-") {
        co = double.parse(value[0][1]['coValue']);
        stationList.add(stationNameList[1]);
      } // 1번 2번 모두 오류시
      else if (value[0][0]['coValue'] == "-" &&
          value[0][1]['coValue'] == "-" &&
          value[0][2]['coValue'] != "-") {
        co = double.parse(value[0][2]['coValue']);
        stationList.add(stationNameList[2]);
      } //1번 2번 3번 모두 오류시
      else if (value[0][0]['coValue'] == "-" &&
          value[0][1]['coValue'] == "-" &&
          value[0][2]['coValue'] == "-") {
        co = 0;
        stationList.add("측정소 점검중");
      } // 1번이 정상일때
      else {
        co = double.parse(value[0][0]['coValue']);
        stationList.add(stationNameList[0]);
      }
      airDataList.add(co);

      //home에 넘겨줄 데이터에 측정데이터값과 측정소 각각의 주소를 넣어준다
      dataBundle['data'] = airDataList;
      dataBundle['station'] = stationList;

      //각항목별 대기질 측정값에 따른 색상 계산
      DustColor.pm10Calc(pm10, ref);
      DustColor.pm25Calc(pm25, ref);
      DustColor.o3Calc(o3, ref);
      DustColor.no2Calc(no2, ref);
      DustColor.so2Calc(so2, ref);
      DustColor.coCalc(co, ref);
    }).then((value) async {
      final pm10Level = ref.watch(pm10LevelProvider);
      final pm25Level = ref.watch(pm25LevelProvider);
      final isPm10 = ref.watch(isPm10Color);

      if (pm10Level < pm25Level) {
        ref.read(isPm10Color.notifier).update((state) => false);
        ref.read(isMessagePm10Provider.notifier).update((state) => false);
      } else if (pm10Level >= pm25Level) {
        ref.read(isPm10Color.notifier).update((state) => true);
        ref.read(isMessagePm10Provider.notifier).update((state) => true);
      } else if (pm10Level == 404 && pm25Level != 404) {
        ref.read(isPm10Color.notifier).update((state) => false);
        ref.read(isMessagePm10Provider.notifier).update((state) => false);
      } else if (pm10Level != 404 && pm25Level == 404) {
        ref.read(isPm10Color.notifier).update((state) => true);
        ref.read(isMessagePm10Provider.notifier).update((state) => true);
      } else if (pm10Level == 404 && pm25Level == 404) {
        ref.read(isPm10Color.notifier).update((state) => true);
        ref.read(isMessagePm10Provider.notifier).update((state) => true);
      }

      if (isPm10 == true) {
        if (pm10Level == 2) {
          ref
              .read(emojiProvider.notifier)
              .update((state) => "lib/assets/image/NICE.png");
        } else if (pm10Level == 3) {
          ref
              .read(emojiProvider.notifier)
              .update((state) => "lib/assets/image/MODERATE.png");
        } else if (pm10Level == 4) {
          ref
              .read(emojiProvider.notifier)
              .update((state) => "lib/assets/image/UNHEALTHY.png");
        } else if (pm10Level == 5) {
          ref
              .read(emojiProvider.notifier)
              .update((state) => "lib/assets/image/VERY_UNHEALTHY.png");
        } else if (pm10Level == 6) {
          ref
              .read(emojiProvider.notifier)
              .update((state) => "lib/assets/image/HAZARDOUS.png");
        } else if (pm10Level == 404) {
          ref
              .read(emojiProvider.notifier)
              .update((state) => "lib/assets/image/FIXING.png");
        } else {
          if (pm25Level == 2) {
            ref
                .read(emojiProvider.notifier)
                .update((state) => "lib/assets/image/NICE.png");
          } else if (pm25Level == 3) {
            ref
                .read(emojiProvider.notifier)
                .update((state) => "lib/assets/image/MODERATE.png");
          } else if (pm25Level == 4) {
            ref
                .read(emojiProvider.notifier)
                .update((state) => "lib/assets/image/UNHEALTHY.png");
          } else if (pm25Level == 5) {
            ref
                .read(emojiProvider.notifier)
                .update((state) => "lib/assets/image/VERY_UNHEALTHY.png");
          } else if (pm25Level == 6) {
            ref
                .read(emojiProvider.notifier)
                .update((state) => "lib/assets/image/HAZARDOUS.png");
          } else if (pm25Level == 404) {
            ref
                .read(emojiProvider.notifier)
                .update((state) => "lib/assets/image/FIXING.png");
          }
        }
      }
    }).then((value) async {
      //사용자 주소획득
      await getAddress();
      await storage.write(key: SAVEDATA, value: jsonEncode(dataBundle));
      final Color bgColor = ref.watch(pm10ColorProvider);
      if (!mounted) return;
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
    final Dio dio = Dio();
    // dio.interceptors.add(CustomInterceptor());
    final Gps2Tm tm;
    tm = Gps2Tm(dio);
    //일반 좌표를 tm 좌표 변환하기위한 토큰 획득
    await tm
        .getAuthToken(
            key: "d7fb11be307f45dcbaa6", secret: "56b1d86baff049ae866a")
        .then((value) async {
      final token = value.result['accessToken'];
      final lat = await storage.read(key: LAT);
      final lng = await storage.read(key: LNG);
      //토큰 획득후 저장소에서 읽어온 현재 좌표를 가져옴
      final res = tm.getTm(
          accessToken: token,
          posX: double.parse(lng!),
          posY: double.parse(lat!),
          dst: 5179);
      return res;
    }).then((value) async {
      //TM 좌표 획득후 해당 TM 좌표로 사용자 주소 획득
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
