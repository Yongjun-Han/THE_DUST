import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
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
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    // print(widget.bgColor);
    // print(widget.data['userSi']);
    // print(widget.data['userDong']);
    // print(widget.data['station']);
    print(widget.data['dust']);
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
    DateTime dt = DateTime.now();
    final time = int.parse("${dt.hour}" "${dt.minute}");
    final GetTemp temp;
    temp = GetTemp(dio);
    final res = await temp.getTemp(
      date: 20230707,
      time: time,
      nx: widget.data['xgrid'],
      ny: widget.data['ygrid'],
    );
    final temperature = res.response['body']['items']['item'][3]['obsrValue'];
    // print(res.response['body']['items']['item'][3]['obsrValue']);
    return temperature;
  }

  @override
  Widget build(BuildContext context) {
    final Color pm10ColorState = ref.watch(pm10ColorProvider);
    final String emojiPath = ref.watch(emojiProvider);
    final String dustMessage = ref.watch(dustMessageProvider);
    DateTime dt = DateTime.now();
    return Scaffold(
      backgroundColor: pm10ColorState,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            print("MENU");
          },
          child: const Icon(Icons.notes_sharp),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              CupertinoIcons.search,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: Icon(
              CupertinoIcons.location_fill,
              color: Colors.black,
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
      body: RefreshIndicator(
        backgroundColor: Colors.black,
        color: pm10ColorState,
        strokeWidth: 3,
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          print("36.343459/127.392446");
        },
        child: SingleChildScrollView(
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
                    "${dt.month}월 ${dt.day}일",
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
                          baseColor: pm10ColorState,
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
              Text(
                "미세먼지 $dustMessage",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 36,
              ),
              const AirCondition(),
              const SizedBox(
                height: 24,
              ),
              const AirCast(),
              const SizedBox(
                height: 24,
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
                        fontSize: 11,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

    // return DefaultLayout(
    //     title: "서구 탄방동",
    //     bgColor: GOOD,
    //     bottomNavigationBar: Theme(
    //       data: ThemeData(
    //         splashColor: Colors.transparent,
    //         highlightColor: Colors.transparent,
    //       ),
    //       child: BottomNavigationBar(
    //         backgroundColor: GOOD,
    //         selectedItemColor: Colors.white,
    //         unselectedItemColor: const Color.fromARGB(255, 95, 95, 95),
    //         selectedFontSize: 10,
    //         unselectedFontSize: 10,
    //         type: BottomNavigationBarType.fixed,
    //         onTap: (int index) {
    //           controller.animateTo(index);
    //         },
    //         currentIndex: index,
    //         items: const [
    //           BottomNavigationBarItem(
    //             icon: Icon(CupertinoIcons.house_alt),
    //             label: '홈',
    //           ),
    //           BottomNavigationBarItem(
    //             icon: Icon(Icons.map_outlined),
    //             label: '설정',
    //           ),
    //         ],
    //       ),
    //     ),
    //     child: TabBarView(
    //       controller: controller,
    //       children: [
    //         Center(
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Text(
    //                 "Grid X : ${widget.xgrid.toString()}",
    //                 style: const TextStyle(
    //                   color: Colors.white,
    //                 ),
    //               ),
    //               Text(
    //                 "Grid X : ${widget.ygrid.toString()}",
    //                 style: const TextStyle(
    //                   color: Colors.white,
    //                 ),
    //               ),
    //               Text(
    //                 "LAT : ${widget.position.latitude.toString()}",
    //                 style: const TextStyle(
    //                   color: Colors.white,
    //                 ),
    //               ),
    //               Text(
    //                 "LNG : ${widget.position.longitude.toString()}",
    //                 style: const TextStyle(
    //                   color: Colors.white,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         const Center(
    //           child: Text(
    //             "settings",
    //             style: TextStyle(
    //               color: Colors.white,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ));