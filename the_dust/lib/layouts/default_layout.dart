import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_dust/color/colors.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final Color? bgColor;
  final String? title;
  final Widget? bottomNavigationBar;

  const DefaultLayout({
    required this.child,
    this.bgColor,
    this.title,
    this.bottomNavigationBar,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor ?? Colors.white,
      appBar: renderAppBar(),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar? renderAppBar() {
    if (title == null) {
      return null;
    } else {
      return AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          title!,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        foregroundColor: Colors.white,
        leading: const Icon(
          Icons.menu,
          color: primaryColor,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.my_location_rounded,
              color: primaryColor,
            ),
          )
        ],
      );
    }
  }
}
