import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_dust/const/color/colors.dart';
import 'package:the_dust/utils/air_condition_notifier.dart';

class MainDrawer extends ConsumerWidget {
  final String today;
  const MainDrawer({
    required this.today,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorState = ref.watch(pm10ColorProvider);
    return Drawer(
      child: Container(
        color: BASIC_MODAL,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                today,
                style: const TextStyle(
                    color: Color.fromARGB(255, 79, 79, 79),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 18,
              ),
              Container(
                height: 120,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 79, 79, 79),
                    borderRadius: BorderRadius.circular(10)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
