import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

void configureAdapter(Dio dio) {
  (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    final client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  };
}
