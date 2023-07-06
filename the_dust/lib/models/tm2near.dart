import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
part 'tm2near.g.dart';

@RestApi(baseUrl: "http://apis.data.go.kr/B552584")
abstract class Tm2NearStation {
  factory Tm2NearStation(Dio dio, {String baseUrl}) = _Tm2NearStation;

  @GET(
      "/MsrstnInfoInqireSvc/getNearbyMsrstnList?serviceKey=1fBa1MM3xBTQkcg0xPlEQqd4JEkxWAqfUlMr/8ak3zBXUPHau8gPpxRkoWLURTNOt/PPKYm5g9KrCGbVs1ohAw==&returnType=json&tmX={tmX}&tmY={tmY}")
  Future<NearStationModel> getNearStation({
    @Path() required double tmX,
    @Path() required double tmY,
  });

  @GET(
      "/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?serviceKey=1fBa1MM3xBTQkcg0xPlEQqd4JEkxWAqfUlMr%2F8ak3zBXUPHau8gPpxRkoWLURTNOt%2FPPKYm5g9KrCGbVs1ohAw%3D%3D&returnType=json&numOfRows=10&pageNo=1&stationName={stationName}&dataTerm=DAILY&ver=1.0")
  Future<AirConditionModel> getAirCondition({
    @Path() required String stationName,
  });
}

@JsonSerializable()
class NearStationModel {
  final Map<String, dynamic> response;

  NearStationModel({
    required this.response,
  });

  factory NearStationModel.fromJson(Map<String, dynamic> json) =>
      _$NearStationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NearStationModelToJson(this);
}

@JsonSerializable()
class AirConditionModel {
  final Map<String, dynamic> response;

  AirConditionModel({
    required this.response,
  });

  factory AirConditionModel.fromJson(Map<String, dynamic> json) =>
      _$AirConditionModelFromJson(json);

  Map<String, dynamic> toJson() => _$AirConditionModelToJson(this);
}


// https://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?serviceKey=1fBa1MM3xBTQkcg0xPlEQqd4JEkxWAqfUlMr%2F8ak3zBXUPHau8gPpxRkoWLURTNOt%2FPPKYm5g9KrCGbVs1ohAw%3D%3D&returnType=json&numOfRows=100&pageNo=1&stationName=%EB%91%94%EC%82%B0%EB%8F%99&dataTerm=DAILY&ver=1.0

// http://apis.data.go.kr/B552584/MsrstnInfoInqireSvc/getNearbyMsrstnList?serviceKey=1fBa1MM3xBTQkcg0xPlEQqd4JEkxWAqfUlMr/8ak3zBXUPHau8gPpxRkoWLURTNOt/PPKYm5g9KrCGbVs1ohAw==&returnType=json&tmX=235230.39382175816&tmY=316227.1171354126