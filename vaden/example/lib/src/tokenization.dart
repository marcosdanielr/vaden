import 'package:vaden/vaden.dart';

@DTO()
class Tokenization {
  final String accessToken;
  final String refreshToken;

  Tokenization(
    this.accessToken,
    this.refreshToken,
  );
}
