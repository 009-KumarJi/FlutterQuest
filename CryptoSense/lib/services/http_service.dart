import 'package:dio/dio.dart';
import '../models/app_config.dart';
import 'package:get_it/get_it.dart';

class HTTPService {
  final Dio _dio = Dio();
  AppConfig? _appConfig;
  String? _baseURL;

  HTTPService() {
    _appConfig = GetIt.instance.get<AppConfig>();
    _baseURL = _appConfig!.COIN_API_BASE_URL;
  }

  Future<Response?> get(String _path) async {
    try {
      String _url = "$_baseURL$_path";
      Response _response = await _dio.get(_url);
      return _response;
    } catch (err) {
      print('HTTPService: Unable to perform this request\nError: $err');
    }
  }
}
