import 'package:vaden/vaden.dart';

@Controller('/product')
class ProductController {
  @Get('/')
  Future<Response> listProducts(Request request) async {
    return Response.ok('List of products');
  }

  @Post('/')
  Future<Response> createProduct(Request request) async {
    return Response.ok('Product created');
  }
}
