import 'package:json_annotation/json_annotation.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:the_dust/models/auth_model.dart';
part 'gps2tm.g.dart';

@RestApi(baseUrl: "https://sgisapi.kostat.go.kr/OpenAPI3")
abstract class Gps2Tm {
  factory Gps2Tm(Dio dio, {String baseUrl}) = _Gps2Tm;

  @GET(
      "/auth/authentication.json?consumer_key={consumer_key}&consumer_secret={consumer_secret}")
  Future<AuthModel> getAuthToken({
    @Path('consumer_key') required String key,
    @Path('consumer_secret') required String secret,
  });

  //일반 좌표 -> 서부원점 좌표 변환
  //TM -> 서부원점(GRS80) dst 5181  // UTM-K (GRS80) -> dst 5179
  @GET(
      "/transformation/transcoord.json?accessToken={accessToken}&src=4326&dst={dst}&posX={posX}&posY={posY}")
  Future<TmModel> getTm({
    @Path() required String accessToken,
    @Path() required double posX,
    @Path() required double posY,
    @Path() required int dst,
  });

  //일반 좌표 -> utmk 좌표 변환
  @GET(
      "/addr/rgeocode.json?accessToken={accessToken}&y_coor={y_coor}&x_coor={x_coor}&addr_type=20")
  Future<AddressModel> getAddress({
    @Path() required String accessToken,
    @Path('x_coor') required double coorX,
    @Path('y_coor') required double coorY,
  });
}

@JsonSerializable()
class TmModel {
  final Map<String, double> result;

  TmModel({
    required this.result,
  });
  factory TmModel.fromJson(Map<String, dynamic> json) =>
      _$TmModelFromJson(json);

  Map<String, dynamic> toJson() => _$TmModelToJson(this);
}

@JsonSerializable()
class AddressModel {
  final List<dynamic> result;

  AddressModel({
    required this.result,
  });
  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);
}

// https://sgisapi.kostat.go.kr/OpenAPI3/addr/rgeocode.json?accessToken=e381ae44-abca-40f6-8400-396fc00c56c8&y_coor=1816234.5196253124&x_coor=990348.6189693178&addr_type=20

// https://sgisapi.kostat.go.kr/OpenAPI3/transformation/transcoord.json?accessToken=7081f6c7-1486-43a0-b22b-a76ce8ff4ba0&src=4326&dst=5181&posX=127.392446&posY=36.343459

// https://sgisapi.kostat.go.kr/OpenAPI3/auth/authentication.json?consumer_key=d7fb11be307f45dcbaa6&consumer_secret=56b1d86baff049ae866a
// https://sgisapi.kostat.go.kr/OpenAPI3/transformation/transcoord.json

// https://sgisapi.kostat.go.kr/OpenAPI3/addr/rgeocode.json?accessToken=0bf0a03a-f8a7-49b7-bcf1-441ad9a90ffb&y_coor=36.343459&x_coor=127.392446
// {
//     "id": "API_0201",
//     "result": {
//         "posY": 316227.1171354126,
//         "posX": 235230.39382175816
//     },
//     "errMsg": "Success",
//     "errCd": 0,
//     "trId": "tuiu_API_0201_1688621442622"
// }
