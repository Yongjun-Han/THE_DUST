import 'package:json_annotation/json_annotation.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class AuthModel {
  final String id, errMsg, trId;
  final Map<String, dynamic> result;
  final int errCd;

  AuthModel({
    required this.id,
    required this.errMsg,
    required this.trId,
    required this.result,
    required this.errCd,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthModelFromJson(json);
}



// {
//     "id": "API_0101",
//     "result": {
//         "accessTimeout": "1688635835772",
//         "accessToken": "7081f6c7-1486-43a0-b22b-a76ce8ff4ba0"
//     },
//     "errMsg": "Success",
//     "errCd": 0,
//     "trId": "qv53_API_0101_1688621435685"
// }