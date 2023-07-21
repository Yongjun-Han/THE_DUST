import 'package:flutter/material.dart';
import 'package:the_dust/const/color/colors.dart';
import 'package:the_dust/layouts/custom_page_route.dart';
import 'package:the_dust/screens/dustgrade_info_screen.dart';

Future<dynamic> drawer(BuildContext context) {
  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 280,
          decoration: const BoxDecoration(
            color: BASIC_MODAL,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          // height: MediaQuery.of(context).size.height,
          child: Center(
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
                      height: 3,
                      decoration: BoxDecoration(
                        color: const Color(0xff5B5B5B),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )
                  ]),
                  const SizedBox(
                    height: 24,
                  ),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Dust",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      Text(
                        ".D",
                        style: TextStyle(
                            color: Color(0xffE4FF3E),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      CustomPageRouter(
                        child: const DustGradeInfoScreen(),
                        direction: AxisDirection.up,
                      ),
                    ),
                    child: Container(
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
                                  color: Color(0xffBEBEBE)))),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xff55A6EA),
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
          ),
        );
      });
}
