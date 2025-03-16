import 'dart:io';

import 'package:example/src/product_dto.dart';
import 'package:vaden/vaden.dart';

@Controller('/hello')
class HelloController {
  @Get('/ping')
  String ping() {
    return 'pong';
  }

  @Get('/map')
  Map<String, String> map() {
    return {'ping': 'pong'};
  }

  @Get('/maplist')
  List<Map<String, dynamic>> mapList() {
    return [
      {'ping': 'pong 1'},
      {'ping': 'pong 2'},
      {'ping': 'pong 3'},
    ];
  }

  @Get('/object')
  List<ProductDto> object() {
    return [
      ProductDto(name: 'Product 1', price: 100.0),
      ProductDto(name: 'Product 2', price: 200.0),
      ProductDto(name: 'Product 3', price: 300.0),
    ];
  }

  @Get('/application.yaml')
  List<int> application() {
    return File('application.yaml').readAsBytesSync();
  }
}
