import 'package:vaden/vaden.dart';

@Controller('/hello')
class HelloController {
  @Get('/ping')
  String ping() {
    return 'pong';
  }
}
