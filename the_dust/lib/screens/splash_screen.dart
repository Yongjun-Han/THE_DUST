import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:the_dust/calc/gps2grid.dart';
import 'package:the_dust/color/colors.dart';
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

    final int xgrid =
        Gps2Grid.gpsToGRID(position.latitude, position.longitude)['x'];
    final int ygrid =
        Gps2Grid.gpsToGRID(position.latitude, position.longitude)['y'];
    // print(position);
    // print(Gps2Grid.gpsToGRID(position.latitude, position.longitude)['x']);
    // print(Gps2Grid.gpsToGRID(position.latitude, position.longitude)['y']);

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            position: position,
            xgrid: xgrid,
            ygrid: ygrid,
            bgColor: GOOD,
            currentLocation: "서구 탄방동",
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
