import 'package:vaden/vaden.dart';

@DTO()
class Dependency with Validator<Dependency> {
  final String name;
  final String description;
  final String key;
  final String tag;

  Dependency({
    required this.name,
    required this.description,
    required this.key,
    required this.tag,
  });

  @override
  LucidValidator<Dependency> validate(ValidatorBuilder<Dependency> builder) {
    builder //
        .ruleFor((d) => d.name, key: 'name')
        .notEmpty();

    builder //
        .ruleFor((d) => d.description, key: 'description')
        .notEmpty();

    builder //
        .ruleFor((d) => d.key, key: 'key')
        .notEmpty()
        .matchesPattern(r"^[a-z0-9_]+$", message: "Invalid key");

    builder //
        .ruleFor((d) => d.tag, key: 'tag')
        .notEmpty()
        .matchesPattern(r"^[A-Z0-9_]+$", message: "Invalid tag");

    return builder;
  }
}
