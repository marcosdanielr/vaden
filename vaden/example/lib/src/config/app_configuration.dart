import 'package:vaden/vaden.dart';

@Component()
class AppConfiguration {
  @Bind()
  ApplicationSettings load() {
    return ApplicationSettings.load('application.yaml');
  }
}
