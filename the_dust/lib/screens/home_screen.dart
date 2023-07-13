import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:the_dust/layouts/drawer.dart';
import 'package:the_dust/models/get_temp.dart';
import 'package:the_dust/utils/air_condition_notifier.dart';
import 'package:the_dust/widgets/air_cast.dart';
import 'package:the_dust/widgets/air_condition.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final Map<dynamic, dynamic> data;
  final Color bgColor;

  const HomeScreen({
    required this.data,
    required this.bgColor,
    super.key,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    print(widget.data);
    //시작과 동시에
    // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    //   showError();
    // });
    // controller = TabController(length: 2, vsync: this);
    // controller.addListener(tabListner);
  }

  // @override
  // void dispose() {
  //   controller.removeListener(tabListner);
  //   super.dispose();
  // }

  // void tabListner() {
  //   setState(() {
  //     index = controller.index;
  //   });
  // }

  Future<String> getTemp() async {
    final Dio dio = Dio();
    // dio.interceptors.add(CustomInterceptor());
    DateTime dt = DateTime.now();
    final int today;
    if (dt.month < 10) {
      today = int.parse("${dt.year}0${dt.month}${dt.day}");
    } else {
      today = int.parse("${dt.year}${dt.month}${dt.day}");
    }

    final int time;
    if (dt.minute <= 40) {
      time = int.parse("${dt.hour - 1}00");
    } else {
      time = int.parse("${dt.hour}00");
    }
    final GetTemp temp;
    temp = GetTemp(dio);
    final res = await temp.getTemp(
      date: today,
      time: time,
      nx: widget.data['xgrid'],
      ny: widget.data['ygrid'],
    );
    final String temperature;
    if (res.response['body'] == null) {
      temperature = "온도";
    } else {
      temperature = res.response['body']['items']['item'][3]['obsrValue'];
    }

    // print("SPLASH $temperature");
    return temperature;
  }

  @override
  Widget build(BuildContext context) {
    final Color pm10ColorState = ref.watch(pm10ColorProvider);
    final Color pm25ColorState = ref.watch(pm25ColorProvider);
    final String emojiPath = ref.watch(emojiProvider);
    final bool dustMessage = ref.watch(isMessagePm10Provider);
    final bool pmColorState = ref.watch(isPm10Color);
    print(pmColorState);
    final String pm10Msg = ref.watch(pm10MessageProvider);
    final String pm25msg = ref.watch(pm25MessageProvider);

    DateTime dt = DateTime.now();
    final String dayOfWeek = DateFormat.EEEE('ko').format(dt).substring(0, 1);
    // print(DateFormat.EEEE('ko').format(dt));
    return Scaffold(
      backgroundColor: pmColorState ? pm10ColorState : pm25ColorState,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            drawer(context);
          },
          child: const Icon(
            Icons.notes_sharp,
            size: 24,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              CupertinoIcons.search,
              color: Colors.black,
              size: 22,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: Icon(
              CupertinoIcons.location_fill,
              color: Colors.black,
              size: 22,
            ),
          ),
        ],
        title: Column(
          children: [
            Text(
              "${widget.data['userSi']} ${widget.data['userDong']}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(
              height: 36,
            ),
            SizedBox(
              width: 120,
              height: 120,
              child: Image.asset(
                emojiPath,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${dt.month}월 ${dt.day}일 [$dayOfWeek]",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                FutureBuilder(
                  future: getTemp(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Shimmer.fromColors(
                        baseColor: Colors.black26,
                        highlightColor: Colors.black38,
                        child: Container(
                          height: 18,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black26,
                          ),
                        ),
                      );
                    }
                    return Text(
                      "${snapshot.data}℃",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  pmColorState ? "미세먼지" : "초미세먼지",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  dustMessage ? pm10Msg : pm25msg,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 36,
            ),
            AirCondition(
              station: widget.data['station'],
              data: widget.data['data'],
            ),
            const SizedBox(
              height: 24,
            ),
            const AirCast(),
            const SizedBox(
              height: 18,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "대기질 측정 정보",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    "한국환경공단과 기상청에서 제공하는 실시간 관측 데이터이며, 관측기관의 사정에 따라 실제 대기환경과 다를 수 있습니다.",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            )
          ],
        ),
      ),
    );
  }
}
