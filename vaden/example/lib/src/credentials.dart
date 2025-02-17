import 'package:vaden/vaden.dart';

@DTO()
class Credentials with Validator<Credentials> {
  @JsonKey('user_name')
  String username;

  String password;

  Credentials(this.username, this.password);

  @override
  LucidValidator<Credentials> validate(ValidatorBuilder<Credentials> builder) {
    builder //
        .ruleFor((c) => c.username, key: 'username')
        .notEmpty();

    builder //
        .ruleFor((c) => c.password, key: 'password')
        .notEmpty()
        .mustHaveLowercase()
        .mustHaveUppercase()
        .mustHaveNumber()
        .mustHaveSpecialCharacter();

    return builder;
  }
}
