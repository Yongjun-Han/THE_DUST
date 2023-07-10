import 'package:flutter/material.dart';

class AirStatusrModel {
  final int level;
  final String status, nameKo, nameEn;
  final Color color;
  final bool isMain;

  AirStatusrModel({
    required this.nameKo,
    required this.nameEn,
    required this.color,
    required this.status,
    required this.level,
    required this.isMain,
  });

  AirStatusrModel copyWith({
    int? level,
    Color? color,
    String? status,
    bool? isMain,
    String? nameKo,
    String? nameEn,
  }) {
    return AirStatusrModel(
      status: status ?? this.status,
      nameKo: nameKo ?? this.nameKo,
      nameEn: nameEn ?? this.nameEn,
      level: level ?? this.level,
      color: color ?? this.color,
      isMain: isMain ?? this.isMain,
    );
  }
}
