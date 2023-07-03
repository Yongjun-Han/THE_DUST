import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:the_dust/layouts/default_layout.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:the_dust/screens/home_screen.dart';
// import 'package:geolocator/geolocator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // print(position);

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            position: position,
          ),
        ),
      );
    });
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



// 데이터포맷	JSON+XML
// End Point	http://apis.data.go.kr/B552584/ArpltnInforInqireSvc
// API 환경 또는 API 호출 조건에 따라 인증키가 적용되는 방식이 다를 수 있습니다.
// 포털에서 제공되는 Encoding/Decoding 된 인증키를 적용하면서 구동되는 키를 사용하시기 바랍니다.
// * 향후 포털에서 더 명확한 정보를 제공하기 위해 노력하겠습니다.
// 일반 인증키
// (Encoding)	
// 1fBa1MM3xBTQkcg0xPlEQqd4JEkxWAqfUlMr%2F8ak3zBXUPHau8gPpxRkoWLURTNOt%2FPPKYm5g9KrCGbVs1ohAw%3D%3D
// 일반 인증키
// (Decoding)	
// 1fBa1MM3xBTQkcg0xPlEQqd4JEkxWAqfUlMr/8ak3zBXUPHau8gPpxRkoWLURTNOt/PPKYm5g9KrCGbVs1ohAw==