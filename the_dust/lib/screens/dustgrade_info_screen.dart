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
              height: 60,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          current = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        width: 100,
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 72, 72, 72),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            items[index],
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
