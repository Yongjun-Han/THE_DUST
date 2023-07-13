import 'package:flutter/material.dart';
import 'package:the_dust/const/color/colors.dart';

Future<dynamic> drawer(BuildContext context) {
  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 350,
          decoration: const BoxDecoration(
            color: BASIC_MODAL,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          // height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xff5B5B5B),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )
                ]),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  "Dust.D",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xff292929),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                      child: Text("Dust.D 미세먼지 기준",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffAFAFAF)))),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xff292929),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.coffee_rounded,
                        size: 20,
                        color: Color(0xff579F74),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        "buy me a coffee",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff579F74),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xff59B2EC), Color(0xff3B63DB)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                      child: Text("App Store 리뷰 작성하기",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                ),
              ],
            ),
          ),
        );
      });
}
