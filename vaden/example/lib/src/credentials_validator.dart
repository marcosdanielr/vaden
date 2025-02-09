import 'package:example/src/credentials.dart';
import 'package:lucid_validation/lucid_validation.dart';
import 'package:vaden/vaden.dart';

@Component()
class CredentialsValidator extends LucidValidator<Credentials> {
  CredentialsValidator() {
    ruleFor((credentials) => credentials.email, key: 'email').validEmail();

    ruleFor((credentials) => credentials.password, key: 'password') //
        .minLength(6)
        .maxLength(20)
        .mustHaveLowercase()
        .mustHaveUppercase()
        .mustHaveNumber()
        .mustHaveSpecialCharacter();
  }
}
