import 'package:example/src/credentials.dart';
import 'package:vaden/vaden.dart';

@DTO()
class OtherCredentials {
  final String other;
  final Credentials credentials;

  OtherCredentials(this.other, this.credentials);
}
