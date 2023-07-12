import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_dust/const/color/colors.dart';
import 'package:the_dust/utils/air_condition_notifier.dart';

// ref
//     .read(emojiProvider.notifier)
//     .update((state) => "lib/assets/image/GOOD.png");
class DustColor {
  //pm10
  static pm10Calc(int pm10Value, WidgetRef ref) {
    if (pm10Value <= 30) {
      ref.read(pm10ColorProvider.notifier).update((state) => GOOD);
      ref.read(pm10MessageProvider.notifier).update((state) => "좋음");
      ref.read(pm10LevelProvider.notifier).update((state) => 1);
    } else if (pm10Value > 30 && pm10Value <= 48) {
      ref.read(pm10ColorProvider.notifier).update((state) => NICE);
      ref.read(pm10MessageProvider.notifier).update((state) => "양호");
      ref.read(pm10LevelProvider.notifier).update((state) => 2);
    } else if (pm10Value > 48 && pm10Value <= 65) {
      ref.read(pm10ColorProvider.notifier).update((state) => MODERATE);
      ref.read(pm10MessageProvider.notifier).update((state) => "보통");
      ref.read(pm10LevelProvider.notifier).update((state) => 3);
    } else if (pm10Value > 65 && pm10Value <= 99) {
      ref.read(pm10ColorProvider.notifier).update((state) => UNHEALTHY);
      ref.read(pm10MessageProvider.notifier).update((state) => "나쁨");
      ref.read(pm10LevelProvider.notifier).update((state) => 4);
    } else if (pm10Value > 99 && pm10Value <= 150) {
      ref.read(pm10ColorProvider.notifier).update((state) => VERY_UNHEALTHY);
      ref.read(pm10MessageProvider.notifier).update((state) => "상당히 나쁨");
      ref.read(pm10LevelProvider.notifier).update((state) => 5);
    } else if (pm10Value > 150) {
      ref.read(pm10ColorProvider.notifier).update((state) => HAZARDOUS);
      ref.read(pm10MessageProvider.notifier).update((state) => "매우나쁨");
      ref.read(pm10LevelProvider.notifier).update((state) => 6);
    }
  }

  //pm25
  static pm25Calc(int pm25Value, WidgetRef ref) {
    if (pm25Value <= 15) {
      ref.read(pm25ColorProvider.notifier).update((state) => GOOD);
      ref.read(pm25MessageProvider.notifier).update((state) => "좋음");
      ref.read(pm25LevelProvider.notifier).update((state) => 1);
    } else if (pm25Value > 15 && pm25Value <= 20) {
      ref.read(pm25ColorProvider.notifier).update((state) => NICE);
      ref.read(pm25MessageProvider.notifier).update((state) => "양호");
      ref.read(pm25LevelProvider.notifier).update((state) => 2);
    } else if (pm25Value > 20 && pm25Value <= 35) {
      ref.read(pm25ColorProvider.notifier).update((state) => MODERATE);
      ref.read(pm25MessageProvider.notifier).update((state) => "보통");
      ref.read(pm25LevelProvider.notifier).update((state) => 3);
    } else if (pm25Value > 35 && pm25Value <= 54) {
      ref.read(pm25ColorProvider.notifier).update((state) => UNHEALTHY);
      ref.read(pm25MessageProvider.notifier).update((state) => "나쁨");
      ref.read(pm25LevelProvider.notifier).update((state) => 4);
    } else if (pm25Value > 54 && pm25Value <= 75) {
      ref.read(pm25ColorProvider.notifier).update((state) => VERY_UNHEALTHY);
      ref.read(pm25MessageProvider.notifier).update((state) => "상당히나쁨");
      ref.read(pm25LevelProvider.notifier).update((state) => 5);
    } else if (pm25Value > 75) {
      ref.read(pm25ColorProvider.notifier).update((state) => HAZARDOUS);
      ref.read(pm25MessageProvider.notifier).update((state) => "매우나쁨");
      ref.read(pm25LevelProvider.notifier).update((state) => 6);
    }
  }

  //오존
  static o3Calc(double o3Value, WidgetRef ref) {
    if (o3Value <= 0.030) {
      ref.read(o3ColorProvider.notifier).update((state) => GOOD);
      ref.read(o3MessageProvider.notifier).update((state) => "좋음");
    } else if (o3Value > 0.030 && o3Value <= 0.060) {
      ref.read(o3ColorProvider.notifier).update((state) => NICE);
      ref.read(o3MessageProvider.notifier).update((state) => "양호");
    } else if (o3Value > 0.060 && o3Value <= 0.090) {
      print("SDFS $o3Value");
      ref.read(o3ColorProvider.notifier).update((state) => MODERATE);
      ref.read(o3MessageProvider.notifier).update((state) => "보통");
    } else if (o3Value > 0.090 && o3Value <= 0.200) {
      ref.read(o3ColorProvider.notifier).update((state) => UNHEALTHY);
      ref.read(o3MessageProvider.notifier).update((state) => "나쁨");
    } else if (o3Value > 0.200 && o3Value <= 0.380) {
      ref.read(o3ColorProvider.notifier).update((state) => VERY_UNHEALTHY);
      ref.read(o3MessageProvider.notifier).update((state) => "뭐어쩌라고");
    } else if (o3Value > 0.380) {
      ref.read(o3ColorProvider.notifier).update((state) => HAZARDOUS);
      ref.read(o3MessageProvider.notifier).update((state) => "매우나쁨");
    }
  }

  //이산화질소
  static no2Calc(double no2Value, WidgetRef ref) {
    if (no2Value <= 0.03) {
      ref.read(o3ColorProvider.notifier).update((state) => GOOD);
      ref.read(o3MessageProvider.notifier).update((state) => "좋음");
    } else if (no2Value > 0.03 && no2Value <= 0.05) {
      ref.read(o3ColorProvider.notifier).update((state) => NICE);
      ref.read(o3MessageProvider.notifier).update((state) => "양호");
    } else if (no2Value > 0.05 && no2Value <= 0.06) {
      ref.read(o3ColorProvider.notifier).update((state) => MODERATE);
      ref.read(o3MessageProvider.notifier).update((state) => "보통");
    } else if (no2Value > 0.06 && no2Value <= 0.17) {
      ref.read(o3ColorProvider.notifier).update((state) => UNHEALTHY);
      ref.read(o3MessageProvider.notifier).update((state) => "나쁨");
    } else if (no2Value > 0.17 && no2Value <= 1.1) {
      ref.read(o3ColorProvider.notifier).update((state) => VERY_UNHEALTHY);
      ref.read(o3MessageProvider.notifier).update((state) => "상당히나쁨");
    } else if (no2Value > 1.1) {
      ref.read(o3ColorProvider.notifier).update((state) => HAZARDOUS);
      ref.read(o3MessageProvider.notifier).update((state) => "매우나쁨");
    }
  }

  //아황산가스
  static so2Calc(double so2Value, WidgetRef ref) {
    if (so2Value <= 2) {
      ref.read(so2ColorProvider.notifier).update((state) => GOOD);
      ref.read(so2MessageProvider.notifier).update((state) => "좋음");
    } else if (so2Value > 2 && so2Value <= 5.5) {
      ref.read(so2ColorProvider.notifier).update((state) => NICE);
      ref.read(so2MessageProvider.notifier).update((state) => "양호");
    } else if (so2Value > 5.5 && so2Value <= 9) {
      ref.read(so2ColorProvider.notifier).update((state) => MODERATE);
      ref.read(so2MessageProvider.notifier).update((state) => "보통");
    } else if (so2Value > 9 && so2Value <= 18) {
      ref.read(so2ColorProvider.notifier).update((state) => UNHEALTHY);
      ref.read(so2MessageProvider.notifier).update((state) => "나쁨");
    } else if (so2Value > 18 && so2Value <= 32) {
      ref.read(so2ColorProvider.notifier).update((state) => VERY_UNHEALTHY);
      ref.read(so2MessageProvider.notifier).update((state) => "상당히나쁨");
    } else if (so2Value > 32) {
      ref.read(so2ColorProvider.notifier).update((state) => HAZARDOUS);
      ref.read(so2MessageProvider.notifier).update((state) => "매우나쁨");
    }
  }

  //일산화탄소
  static coCalc(double coValue, WidgetRef ref) {
    if (coValue <= 0.02) {
      ref.read(o3ColorProvider.notifier).update((state) => GOOD);
      ref.read(o3MessageProvider.notifier).update((state) => "좋음");
    } else if (coValue > 0.02 && coValue <= 0.04) {
      ref.read(o3ColorProvider.notifier).update((state) => NICE);
      ref.read(o3MessageProvider.notifier).update((state) => "양호");
    } else if (coValue > 0.04 && coValue <= 0.05) {
      ref.read(o3ColorProvider.notifier).update((state) => MODERATE);
      ref.read(o3MessageProvider.notifier).update((state) => "보통");
    } else if (coValue > 0.05 && coValue <= 0.17) {
      ref.read(o3ColorProvider.notifier).update((state) => UNHEALTHY);
      ref.read(o3MessageProvider.notifier).update((state) => "나쁨");
    } else if (coValue > 0.17 && coValue <= 0.6) {
      ref.read(o3ColorProvider.notifier).update((state) => VERY_UNHEALTHY);
      ref.read(o3MessageProvider.notifier).update((state) => "상당히나쁨");
    } else if (coValue > 0.6) {
      ref.read(o3ColorProvider.notifier).update((state) => HAZARDOUS);
      ref.read(o3MessageProvider.notifier).update((state) => "매우나쁨");
    }
  }
}
