// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tm2near.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NearStationModel _$NearStationModelFromJson(Map<String, dynamic> json) =>
    NearStationModel(
      response: json['response'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$NearStationModelToJson(NearStationModel instance) =>
    <String, dynamic>{
      'response': instance.response,
    };

AirConditionModel _$AirConditionModelFromJson(Map<String, dynamic> json) =>
    AirConditionModel(
      response: json['response'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$AirConditionModelToJson(AirConditionModel instance) =>
    <String, dynamic>{
      'response': instance.response,
    };

AirCastModel _$AirCastModelFromJson(Map<String, dynamic> json) => AirCastModel(
      response: json['response'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$AirCastModelToJson(AirCastModel instance) =>
    <String, dynamic>{
      'response': instance.response,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _Tm2NearStation implements Tm2NearStation {
  _Tm2NearStation(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'http://apis.data.go.kr/B552584';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<NearStationModel> getNearStation({
    required tmX,
    required tmY,
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<NearStationModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/MsrstnInfoInqireSvc/getNearbyMsrstnList?serviceKey=1fBa1MM3xBTQkcg0xPlEQqd4JEkxWAqfUlMr/8ak3zBXUPHau8gPpxRkoWLURTNOt/PPKYm5g9KrCGbVs1ohAw==&returnType=json&tmX=${tmX}&tmY=${tmY}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NearStationModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AirConditionModel> getAirCondition({required stationName}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<AirConditionModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?serviceKey=1fBa1MM3xBTQkcg0xPlEQqd4JEkxWAqfUlMr%2F8ak3zBXUPHau8gPpxRkoWLURTNOt%2FPPKYm5g9KrCGbVs1ohAw%3D%3D&returnType=json&numOfRows=1&pageNo=1&stationName=${stationName}&dataTerm=DAILY&ver=1.0',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AirConditionModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AirCastModel> getCast({required searchDate}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<AirCastModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/ArpltnInforInqireSvc/getMinuDustFrcstDspth?serviceKey=1fBa1MM3xBTQkcg0xPlEQqd4JEkxWAqfUlMr%2F8ak3zBXUPHau8gPpxRkoWLURTNOt%2FPPKYm5g9KrCGbVs1ohAw%3D%3D&returnType=json&numOfRows=100&pageNo=1&searchDate=${searchDate}&InformCode=PM10',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AirCastModel.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
