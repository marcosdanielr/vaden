import 'package:vaden/vaden.dart';

@DTO()
class Credentials with Validator<Credentials> {
  final String email;

  final String password;

  Credentials(this.email, this.password);

  // Na geração de código, colocar um Credentials.fromJson depois de pegar o corpo da requisição
  static Credentials fromJson(Map<String, dynamic> json) {
    return Credentials(json['email'], json['password']);
  }

  // Na geração de código validar automaticamente e retornar um badrequest ser der problema
  @override
  LucidValidator<Credentials> validate(ValidatorBuilder<Credentials> builder) {
    builder //
        .ruleFor((c) => c.email, key: 'email')
        .validEmail();

    builder //
        .ruleFor((c) => c.password, key: 'password')
        .minLength(6)
        .maxLength(20)
        .mustHaveLowercase()
        .mustHaveUppercase()
        .mustHaveNumber()
        .mustHaveSpecialCharacter();

    return builder;
  }
}
