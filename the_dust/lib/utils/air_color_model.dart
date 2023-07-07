import 'package:flutter/material.dart';

class AirColorModel {
  final int level;
  final Color color;
  final bool isSelected;

  AirColorModel({
    required this.color,
    required this.level,
    required this.isSelected,
  });

  AirColorModel copyWith({
    int? level,
    Color? color,
    bool? isSelected,
  }) {
    return AirColorModel(
      level: level ?? this.level,
      color: color ?? this.color,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
