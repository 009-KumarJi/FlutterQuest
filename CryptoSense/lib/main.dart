import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import '/pages/home_page.dart';
import 'package:flutter/material.dart';

import 'models/app_config.dart';
import 'services/http_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig to work properly on Android.
  await loadConfig();
  registerHTTPService();
  await GetIt.instance.get<HTTPService>().get('/coins/bitcoin');
  runApp(const MyApp());
}

Future<void> loadConfig() async {
  String _configContent = await rootBundle.loadString('assets/config/main.json');
  Map _configData = jsonDecode(_configContent);
  GetIt.instance.registerSingleton<AppConfig>(
    AppConfig(
      COIN_API_BASE_URL: _configData['COIN_API_BASE_URL'],
    ),
  );
}

void registerHTTPService() {
  GetIt.instance.registerSingleton<HTTPService>(
    HTTPService(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CryptoSense',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(29, 1, 120, 1.0),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
