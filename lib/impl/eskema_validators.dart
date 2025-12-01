import 'package:eskema/eskema.dart';
import 'package:openid4vp_dcql/openid4vp_dcql.dart';

final notEmptyList = listLength([isGte(1)], message: 'List must not be empty');
final notEmptyMap = length([isGte(0)], message: 'Map must not be empty');

/// Validator for [TrustedAuthority]
final trustedAuthorityValidator = eskema({
  'type': isString(),
  'values': listEach(isString()) & notEmptyList,
});

final idValidator = stringMatchesPattern(
  RegExp(r'^[a-zA-Z0-9_-]+$'),
  message: "ID must be an alpha-numeric string with underscores and hyphens",
);

final pathValidator = listEach(
          any(
            [isString(), (isInt() & isGte(0)), isNull()],
          ),
        ) &
        notEmptyList >
    Expectation(
      message: "Path must be a non-empty list of strings, ints (>=0), or null",
    );

final mdocMetaValidator = eskema({
  'doctype_value': isString(message: "must be a string"),
});

final sdJwtMetaValidator = eskema({
  'vct_values': listEach(isString(), message: "must be a list of strings"),
});

void main() {
  print("Valid: ${idValidator.validate("cred-1").isValid}");
  print(idValidator.validate("cred-1"));
}
