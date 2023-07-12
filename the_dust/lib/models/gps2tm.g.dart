// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gps2tm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TmModel _$TmModelFromJson(Map<String, dynamic> json) => TmModel(
      result: (json['result'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
    );

Map<String, dynamic> _$TmModelToJson(TmModel instance) => <String, dynamic>{
      'result': instance.result,
    };

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) => AddressModel(
      result: json['result'] as List<dynamic>,
    );

Map<String, dynamic> _$AddressModelToJson(AddressModel instance) =>
    <String, dynamic>{
      'result': instance.result,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _Gps2Tm implements Gps2Tm {
  _Gps2Tm(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'https://sgisapi.kostat.go.kr/OpenAPI3';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<AuthModel> getAuthToken({
    required key,
    required secret,
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<AuthModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/auth/authentication.json?consumer_key=${key}&consumer_secret=${secret}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AuthModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<TmModel> getTm({
    required accessToken,
    required posX,
    required posY,
    required dst,
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result =
        await _dio.fetch<Map<String, dynamic>>(_setStreamType<TmModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/transformation/transcoord.json?accessToken=${accessToken}&src=4326&dst=${dst}&posX=${posX}&posY=${posY}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = TmModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AddressModel> getAddress({
    required accessToken,
    required coorX,
    required coorY,
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<AddressModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/addr/rgeocode.json?accessToken=${accessToken}&y_coor=${coorY}&x_coor=${coorX}&addr_type=20',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AddressModel.fromJson(_result.data!);
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
