import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:the_dust/layouts/default_layout.dart';

class HomeScreen extends StatefulWidget {
  final Position position;

  const HomeScreen({
    required this.position,
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
    // print(widget.position);
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
    return DefaultLayout(
        title: "서구 탄방동",
        bgColor: Colors.black,
        bottomNavigationBar: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            backgroundColor: const Color.fromARGB(255, 20, 20, 20),
            selectedItemColor: Colors.white,
            unselectedItemColor: const Color.fromARGB(255, 95, 95, 95),
            selectedFontSize: 10,
            unselectedFontSize: 10,
            type: BottomNavigationBarType.fixed,
            onTap: (int index) {
              controller.animateTo(index);
            },
            currentIndex: index,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.house_alt),
                label: '홈',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                label: '설정',
              ),
            ],
          ),
        ),
        child: TabBarView(
          controller: controller,
          children: const [
            Center(
              child: Text(
                "hello :)",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Center(
              child: Text(
                "settings",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ));
  }
}
