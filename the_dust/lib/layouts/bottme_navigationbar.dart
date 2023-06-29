import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  // final Widget? bottomNavigationBar;

  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.amber,
      unselectedItemColor: Colors.red,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState(() {
          this.index = index;
        });
      },
      currentIndex: index,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.house_alt),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          label: '주변',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.route_outlined),
          label: '여행짜기',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.photo_camera_back),
          label: '댕생네컷',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border_outlined),
          label: 'MY',
        ),
      ],
    );
  }
}
