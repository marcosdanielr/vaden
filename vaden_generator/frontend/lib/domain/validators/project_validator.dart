import 'package:lucid_validation/lucid_validation.dart';

import '../entities/project.dart';

class ProjectValidator extends LucidValidator<Project> {
  ProjectValidator() {
    ruleFor((p) => p.name, key: 'name') //
        .notEmpty()
        .minLength(3)
        .maxLength(50)
        .matchesPattern(r'^[a-z][a-z0-9_]*$', code: 'invalid_name');

    ruleFor((p) => p.description, key: 'description') //
        .notEmpty()
        .minLength(3)
        .maxLength(100);

    ruleFor((p) => p.dartVersion, key: 'dartVersion') //
        .notEmpty()
        .matchesPattern(r'^\d+\.\d+\.\d+$', code: 'invalid_version');
  }
}
