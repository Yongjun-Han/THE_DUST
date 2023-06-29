import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_dust/screens/splash_screen.dart';

void main() {
  runApp(const ProviderScope(child: _App()));
}

class _App extends StatelessWidget {
  const _App();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Pretendard',
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      // home: const OnBoard(),
    );
  }
}

// Future<bool> fetchData() async {
//   bool data = false;

//   // Change to API call
//   await Future.delayed(Duration(seconds: 3), () {
//     data = true;
//   });

//   return data;
// }
