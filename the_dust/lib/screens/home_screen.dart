import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_dust/color/colors.dart';
import 'package:the_dust/widgets/air_cast.dart';
import 'package:the_dust/widgets/air_condition.dart';

class HomeScreen extends StatefulWidget {
  final Map<dynamic, dynamic> data;
  // final Position position;
  // final int xgrid;
  // final int ygrid;
  final Color bgColor;
  // final String currentLocation;

  const HomeScreen({
    required this.data,
    // required this.position,
    // required this.xgrid,
    // required this.ygrid,
    required this.bgColor,
    // required this.currentLocation,
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  int index = 0;

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 2, vsync: this);
    controller.addListener(tabListner);
  }

  @override
  void dispose() {
    controller.removeListener(tabListner);
    super.dispose();
  }

  void tabListner() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.bgColor,
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
        title: const Column(
          children: [
            Text(
              "서구 탄방동",
              style: TextStyle(
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
        color: GOOD,
        strokeWidth: 3,
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          print("DD");
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
                  "lib/assets/image/GOOD.png",
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                height: 36,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "06.30 금요일",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    "17℃",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              const Text(
                "미세먼지 좋음",
                style: TextStyle(
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