// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthModel _$AuthModelFromJson(Map<String, dynamic> json) => AuthModel(
      id: json['id'] as String,
      errMsg: json['errMsg'] as String,
      trId: json['trId'] as String,
      result: json['result'] as Map<String, dynamic>,
      errCd: json['errCd'] as int,
    );

Map<String, dynamic> _$AuthModelToJson(AuthModel instance) => <String, dynamic>{
      'id': instance.id,
      'errMsg': instance.errMsg,
      'trId': instance.trId,
      'result': instance.result,
      'errCd': instance.errCd,
    };
