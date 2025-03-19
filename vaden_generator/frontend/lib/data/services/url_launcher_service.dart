import 'package:result_dart/result_dart.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  AsyncResult<Unit> launch(String url) async {
    await launchUrl(Uri.parse(url));
    return Success(unit);
  }
}
