import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_dust/const/color/colors.dart';

class DustGradeInfoScreen extends StatefulWidget {
  const DustGradeInfoScreen({super.key});

  @override
  State<DustGradeInfoScreen> createState() => _DustGradeInfoScreenState();
}

class _DustGradeInfoScreenState extends State<DustGradeInfoScreen> {
  List<String> items = [
    "미세먼지",
    "초미세먼지",
    "오존",
    "이산화질소",
    "아황산가스",
    "일산화탄소",
  ];

  List<String> images = [
    "lib/assets/image/미세먼지 등급.png",
    "lib/assets/image/초미세먼지 등급.png",
    "lib/assets/image/오존 등급.png",
    "lib/assets/image/이산화질소 등급.png",
    "lib/assets/image/아황산가스 등급.png",
    "lib/assets/image/일산화탄소 등급.png",
  ];

  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BASIC_MODAL,
        elevation: 0,
        title: const Text(
          "Dust.D 미세먼지 6단계 기준",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Container(
        color: BASIC_MODAL,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 72,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              current = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.all(6),
                            width: 100,
                            height: 45,
                            decoration: BoxDecoration(
                              color: current == index
                                  ? const Color.fromARGB(255, 72, 72, 72)
                                  : Colors.black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                items[index],
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: current == index
                                        ? Colors.white
                                        : const Color.fromARGB(
                                            255, 72, 72, 72)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Visibility(
                            visible: current == index,
                            child: Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ))
                      ],
                    );
                  }),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        images[current],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(18.0),
              child: Text(
                "주의 : Dust.D는 위 기준치를 사용함으로 인해 생기는 문제에 대해 책임이 없음을 말씀드립니다",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
