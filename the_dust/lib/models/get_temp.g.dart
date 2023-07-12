// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_temp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TempModel _$TempModelFromJson(Map<String, dynamic> json) => TempModel(
      response: json['response'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$TempModelToJson(TempModel instance) => <String, dynamic>{
      'response': instance.response,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _GetTemp implements GetTemp {
  _GetTemp(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'https://apis.data.go.kr/1360000';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<TempModel> getTemp({
    required date,
    required time,
    required nx,
    required ny,
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<TempModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/VilageFcstInfoService_2.0/getUltraSrtNcst?serviceKey=1fBa1MM3xBTQkcg0xPlEQqd4JEkxWAqfUlMr%2F8ak3zBXUPHau8gPpxRkoWLURTNOt%2FPPKYm5g9KrCGbVs1ohAw%3D%3D&pageNo=1&numOfRows=1000&dataType=json&base_date=${date}&base_time=${time}&nx=${nx}&ny=${ny}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = TempModel.fromJson(_result.data!);
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
