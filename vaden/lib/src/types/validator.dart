import 'package:lucid_validation/lucid_validation.dart';

mixin Validator<T> {
  LucidValidator<T> validate(ValidatorBuilder<T> builder);
}

class ValidatorBuilder<T> extends LucidValidator<T> {}
