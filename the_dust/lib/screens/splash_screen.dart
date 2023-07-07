import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:the_dust/calc/gps2grid.dart';
import 'package:the_dust/color/colors.dart';
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
    final List xygrid = [];
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
    }).then((value) {
      //홈으로 넘겨줄 미세먼지 측정 관측소 이름
      dataBundle['station'] = value.response['body']['items'][0]['stationName'];
      // print(value.response['body']['items'][0]['stationName']);
      final station = value.response['body']['items'][0]['stationName'];
      final Tm2NearStation condition;
      condition = Tm2NearStation(dio);
      final res = condition.getAirCondition(stationName: station);
      return res;
    }).then((value) {
      // final List<AirColorModel> airColorState = ref.watch(airColorProvider);
      // final pm10level = int.parse(
      //   value.response['body']['items'][0]['pm10Value'],
      // );
      const pm10level = 60;
      // final pm25level = int.parse(
      //   value.response['body']['items'][0]['pm25Value'],
      // );
      // print(value.response['body']['items'][0]);
      //홈으로 넘겨줄 미세먼지 측정 데이터
      dataBundle['dust'] = value.response['body']['items'][0];
      if (pm10level <= 30) {
        ref.read(pm10ColorProvider.notifier).update((state) => GOOD);
      } else if (pm10level > 30 && pm10level <= 48) {
        ref.read(pm10ColorProvider.notifier).update((state) => NICE);
        ref
            .read(emojiProvider.notifier)
            .update((state) => "lib/assets/image/NICE.png");
        ref.read(dustMessageProvider.notifier).update((state) => "양호");
      } else if (pm10level > 48 && pm10level <= 65) {
        ref.read(pm10ColorProvider.notifier).update((state) => MODERATE);
        ref
            .read(emojiProvider.notifier)
            .update((state) => "lib/assets/image/MODERATE.png");
        ref.read(dustMessageProvider.notifier).update((state) => "보통");
      } else if (pm10level > 65 && pm10level <= 99) {
        ref.read(pm10ColorProvider.notifier).update((state) => UNHEALTHY);
        ref
            .read(emojiProvider.notifier)
            .update((state) => "lib/assets/image/UNHEALTHY.png");
        ref.read(dustMessageProvider.notifier).update((state) => "나쁨");
      } else if (pm10level > 99 && pm10level <= 150) {
        ref.read(pm10ColorProvider.notifier).update((state) => VERY_UNHEALTHY);
        ref
            .read(emojiProvider.notifier)
            .update((state) => "lib/assets/image/VERY_UNHEALTHY.png");
        ref.read(dustMessageProvider.notifier).update((state) => "상당히 나쁨");
      } else if (pm10level > 150) {
        ref.read(pm10ColorProvider.notifier).update((state) => HAZARDOUS);
        ref
            .read(emojiProvider.notifier)
            .update((state) => "lib/assets/image/HAZARDOUS.png");
        ref.read(dustMessageProvider.notifier).update((state) => "매우나쁨");
      }
    }).then((value) async {
      await getAddress();
    }).then((value) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            data: dataBundle,
            bgColor: GOOD,
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
