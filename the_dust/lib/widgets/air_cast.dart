import 'package:flutter/material.dart';
import 'package:the_dust/components/cast_card.dart';

class AirCast extends StatelessWidget {
  const AirCast({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "미세먼지 예보",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            CastCard(
              title: "오늘",
              message: "원활한 대기 확산으로 대기질이 대체로 청정할 것으로 예상됩니다.",
            ),
            SizedBox(
              height: 12,
            ),
            CastCard(
              title: "내일",
              message: "원활한 대기 확산으로 대기질이 대체로 청정할 것으로 예상됩니다.",
            ),
          ],
        ),
      ),
    );
  }
}
