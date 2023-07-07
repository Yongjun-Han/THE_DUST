import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:json_annotation/json_annotation.dart';
part 'get_temp.g.dart';

@RestApi(baseUrl: "https://apis.data.go.kr/1360000")
abstract class GetTemp {
  factory GetTemp(Dio dio, {String baseUrl}) = _GetTemp;

  @GET(
      "/VilageFcstInfoService_2.0/getUltraSrtNcst?serviceKey=1fBa1MM3xBTQkcg0xPlEQqd4JEkxWAqfUlMr%2F8ak3zBXUPHau8gPpxRkoWLURTNOt%2FPPKYm5g9KrCGbVs1ohAw%3D%3D&pageNo=1&numOfRows=1000&dataType=json&base_date={base_date}&base_time={base_time}&nx={nx}&ny={ny}")
  Future<TempModel> getTemp({
    @Path('base_date') required int date,
    @Path('base_time') required int time,
    @Path() required int nx,
    @Path() required int ny,
  });
}

@JsonSerializable()
class TempModel {
  final Map<String, dynamic> response;

  TempModel({
    required this.response,
  });

  factory TempModel.fromJson(Map<String, dynamic> json) =>
      _$TempModelFromJson(json);

  Map<String, dynamic> toJson() => _$TempModelToJson(this);
}





// https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst?serviceKey=1fBa1MM3xBTQkcg0xPlEQqd4JEkxWAqfUlMr%2F8ak3zBXUPHau8gPpxRkoWLURTNOt%2FPPKYm5g9KrCGbVs1ohAw%3D%3D&pageNo=1&numOfRows=1000&dataType=json&base_date=20230707&base_time=1300&nx=67&ny=100