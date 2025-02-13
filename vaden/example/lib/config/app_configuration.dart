import 'package:vaden/vaden.dart';

@Configuration()
class AppConfiguration {
  @Bind()
  ApplicationSettings settings() {
    return ApplicationSettings.load('application.yaml');
  }

  @Bind()
  Storage configStorage(ApplicationSettings settings) {
    return Storage.createStorageService(settings);
  }

  @Bind()
  Pipeline globalMiddleware(ApplicationSettings settings) {
    return Pipeline() //
        .addMiddleware(logRequests());
  }
}
