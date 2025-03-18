import 'package:dio/dio.dart';
import 'package:vaden/vaden.dart';

@Configuration()
class DioConfiguration {
  @Bean()
  Dio dioApoiaseConfig(ApplicationSettings settings) {
    return Dio(
      BaseOptions(
        baseUrl: settings['apoia_se']['url'],
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': settings['apoia_se']['key'],
          'Authorization': 'Bearer ${settings['apoia_se']['secret']}',
        },
      ),
    );
  }
}
