import 'package:eskema/eskema.dart';
import 'package:openid4vp_dcql/openid4vp_dcql.dart';

final notEmptyList = listLength([isGte(1)], message: 'List must not be empty');
final notEmptyMap = length([isGte(0)], message: 'Map must not be empty');

/// Validator for [TrustedAuthority]
final trustedAuthorityValidator = eskema({
  'type': isString(),
  'values': listEach(isString()) & notEmptyList,
});

final idValidator = all(
  [isString(), stringMatchesPattern(RegExp(r'^[a-zA-Z0-9_-]+$'))],
  message: "ID must be an alpha-numeric string with underscores and hyphens",
);

/// Validator for [Claim]
final claimValidator = eskema({
  'id': optional(idValidator),
  'path': listEach(isString() | (isInt() & isGte(0))) & not(listEmpty()),
  'values': optional(listEach(isString() | (isInt() & isGte(0)) | isBool())),
});

/// Validator for [CredentialSet]
final credentialSetValidator = eskema({
  'options': listEach(listEach(idValidator) & notEmptyList) & notEmptyList,
  'required': optional(isBool()),
});

final commonCredentialFields = {
  'id': idValidator,
  'multiple': optional(isBool()),
  'claims': optional(listEach(claimValidator)),
  'claim_sets': optional(listEach(listEach(idValidator)) & notEmptyList),
  'trustedAuthorities': optional(listEach(trustedAuthorityValidator)),
  'requireCryptographicHolderBinding': optional(isBool()),
};

final mdocMetaValidator = isMap() &
    eskema({
      'doctype_value': isString(message: "must be a string"),
    });

final sdJwtMetaValidator = isMap() &
    eskema({
      'vct_values': listEach(isString(), message: "must be a list of strings"),
    });

final baseCredentialValidator = {
  'id': idValidator,
  'format': isOneOf(Formats.values.map((f) => f.name).toList()) | isString(),
  'meta': isMap(),
};

/// Validator for [Credential]
final sdJwtCredentialValidator = isMap() &
    eskema({
      ...baseCredentialValidator,
      'meta': sdJwtMetaValidator,
    });

final mdocCredentialValidator = isMap() &
    eskema({
      ...baseCredentialValidator,
      'meta': mdocMetaValidator,
    });

final credentialValidator = sdJwtCredentialValidator | mdocCredentialValidator;

/// Root validator for [DcqlQuery]
final dcqlQueryValidator = eskema({
  'credentials': listEach(credentialValidator) & notEmptyList,
  'credential_sets': optional(listEach(credentialSetValidator) & notEmptyList),
});

void main() {
  print(
    credentialValidator.validate({
      'id': 'cred_1',
      'format': 'mso_mdoc',
      'meta': {
        'doctype_value': 'mso_mdoc',
      },
    }),
  );

  // Example Usage
  final queryJson = {
    'credentials': [
      {
        'id': 'cred_1',
        'format': 'mso_mdoc',
        'meta': {
          'doctype_value': 'mso_mdoc',
        },
        'claims': [
          {
            'path': ['org.iso.18013.5.1', 'family_name'],
          },
          {
            'path': ['org.iso.18013.5.1', 'given_name'],
          }
        ],
      },
      {
        'id': 'cred_2',
        'format': Formats.sd_jwt.name,
        'meta': {},
        'claims': [
          {
            'path': ['family_name'],
          },
          {
            'path': ['given_name'],
          }
        ],
      }
    ],
    'credential_sets': [
      {
        'options': [
          ['cred_1'],
        ],
        'required': true,
      }
    ],
  };

  final result = dcqlQueryValidator.validate(queryJson);

  if (result.isValid) {
    print('DCQL Query is valid!');
  } else {
    print('Validation failed: ');
    for (var error in result.expectations) {
      print(' - ${error.path}: ${error.message}');
    }
  }
}
