import 'package:openid4vp_dcql/model/claim.dart';
import 'package:openid4vp_dcql/model/credential.dart';
import 'package:openid4vp_dcql/model/credential_set.dart';
import 'package:openid4vp_dcql/model/dcql_query.dart';
import 'package:openid4vp_dcql/impl/default_validation.dart';
import 'package:openid4vp_dcql/impl/formats.dart';
import 'package:openid4vp_dcql/validation/dcql_validator.dart';
import 'package:test/test.dart';

void main() {
  final validator = DcqlValidator();

  group('DCQL Validation', () {
    test('Valid simple query passes', () {
      final query = DcqlQuery()
        ..credentials.add(Credential(id: 'c1', format: Formats.mdoc));

      final result = validator.validate(query);
      expect(result.isValid, isTrue);
    });

    test('Fails if credentials list is empty', () {
      final query = DcqlQuery();
      // No credentials added
      final result = validator.validate(query);
      expect(result.isValid, isFalse);
      expect(result.contextPath, equals('query.credentials'));
      expect(
        result.errors?.first,
        contains('DCQL query must contain at least one credential'),
      );
    });

    test('Fails if credential ID is invalid', () {
      final query = DcqlQuery()
        ..credentials.add(Credential(id: '', format: Formats.mdoc)); // Empty ID

      final result = validator.validate(query);
      expect(result.isValid, isFalse);
      expect(result.contextPath, equals('query.credentials[0].id'));
      expect(
        result.errors?.first,
        contains(
          'Credential ID cannot be empty & must consist of alphanumeric',
        ),
      );
    });

    test('Fails if duplicate credential IDs exist', () {
      final query = DcqlQuery()
        ..credentials.addAll([
          Credential(id: 'c1', format: Formats.mdoc),
          Credential(id: 'c1', format: Formats.jwt),
        ]);

      final result = validator.validate(query);
      expect(result.isValid, isFalse);
      expect(result.contextPath, equals('query.credentials[1].id'));
      expect(
        result.errors?.first,
        contains('Duplicate credential ID "c1" found'),
      );
    });

    group('Claims Validation', () {
      test('Fails if claim path is empty', () {
        final query = DcqlQuery()
          ..credentials.add(
            Credential(
              id: 'c1',
              format: Formats.mdoc,
              claims: [
                Claim(path: []),
              ],
            ),
          );

        final result = validator.validate(query);
        expect(result.isValid, isFalse);
        expect(
          result.contextPath,
          equals('query.credentials[0].claims[0].path'),
        );
        expect(
          result.errors?.first,
          contains(
            'Path must be a non-empty list of strings, ints (>=0), or null',
          ),
        );
      });

      test('Fails if claim ID is invalid', () {
        final query = DcqlQuery()
          ..credentials.add(
            Credential(
              id: 'c1',
              format: Formats.mdoc,
              claims: [
                Claim(id: 'invalid id!', path: ['path']),
              ],
            ),
          );

        final result = validator.validate(query);
        expect(result.isValid, isFalse);
        expect(result.contextPath, equals('query.credentials[0].claims[0].id'));
        expect(
          result.errors?.first,
          contains(
            'ID must be an alpha-numeric string with underscores and hyphens',
          ),
        );
      });

      test('Fails if duplicate claim IDs exist within a credential', () {
        final query = DcqlQuery()
          ..credentials.add(
            Credential(
              id: 'c1',
              format: Formats.mdoc,
              claims: [
                Claim(id: 'claim1', path: ['path1']),
                Claim(id: 'claim1', path: ['path2']),
              ],
            ),
          );

        final result = validator.validate(query);
        expect(result.isValid, isFalse);
        expect(result.contextPath, equals('query.credentials[0].claims[1].id'));
        expect(
          result.errors?.first,
          contains('Duplicate claim ID "claim1" found'),
        );
      });

      test('Fails if claim values are invalid types', () {
        final query = DcqlQuery()
          ..credentials.add(
            Credential(
              id: 'c1',
              format: Formats.mdoc,
              claims: [
                Claim(path: ['path'], values: [1.5]), // Double is not allowed
              ],
            ),
          );

        final result = validator.validate(query);
        expect(result.isValid, isFalse);
        expect(
          result.contextPath,
          equals('query.credentials[0].claims[0].values[0]'),
        );
        expect(
          result.errors?.first,
          contains('Claim "values" must be String, int, or bool'),
        );
      });

      test('Fails if claim values list is empty', () {
        final query = DcqlQuery()
          ..credentials.add(
            Credential(
              id: 'c1',
              format: Formats.mdoc,
              claims: [
                Claim(path: ['path'], values: []), // Empty values list
              ],
            ),
          );

        final result = validator.validate(query);
        expect(result.isValid, isFalse);
        expect(
          result.contextPath,
          equals('query.credentials[0].claims[0].values'),
        );
        expect(
          result.errors?.first,
          contains('Claim "values" cannot be an empty list'),
        );
      });

      test('Fails if claim path contains invalid types', () {
        final query = DcqlQuery()
          ..credentials.add(
            Credential(
              id: 'c1',
              format: Formats.mdoc,
              claims: [
                Claim(path: ['path', 1.5]), // Double is not allowed in path
              ],
            ),
          );

        final result = validator.validate(query);
        expect(result.isValid, isFalse);
        expect(
          result.contextPath,
          equals('query.credentials[0].claims[0].path'),
        );
        expect(
          result.errors?.first,
          contains(
            'Path must be a non-empty list of strings, ints (>=0), or null',
          ),
        );
      });
    });

    group('Claim Sets Logic', () {
      test('Claim ID is REQUIRED if claim_sets is present', () {
        final query = DcqlQuery()
          ..credentials.add(
            Credential(
              id: 'c1',
              format: Formats.mdoc,
              claims: [
                Claim(path: ['path']), // Missing ID
              ],
              claimSets: [
                ['some_id'],
              ],
            ),
          );

        final result = validator.validate(query);
        expect(result.isValid, isFalse);
        expect(result.contextPath, equals('query.credentials[0].claims[0].id'));
        expect(
          result.errors?.first,
          contains('Claim ID is required if "claim_sets" is present'),
        );
      });

      test('Claim ID is OPTIONAL if claim_sets is absent', () {
        final query = DcqlQuery()
          ..credentials.add(
            Credential(
              id: 'c1',
              format: Formats.mdoc,
              claims: [
                Claim(path: ['path']), // Missing ID, but okay
              ],
              claimSets: null,
            ),
          );

        final result = validator.validate(query);
        expect(result.isValid, isTrue);
      });

      test('Fails if claim set references unknown claim ID', () {
        final query = DcqlQuery()
          ..credentials.add(
            Credential(
              id: 'c1',
              format: Formats.mdoc,
              claims: [
                Claim(id: 'claim1', path: ['path']),
              ],
              claimSets: [
                ['claim1', 'unknown_claim'],
              ],
            ),
          );

        final result = validator.validate(query);
        expect(result.isValid, isFalse);
        expect(
          result.contextPath,
          equals('query.credentials[0].claim_sets[0][1]'),
        );
        expect(
          result.errors?.first,
          contains(
            'Claim ID "unknown_claim" in claim set does not match any claim',
          ),
        );
      });
    });

    group('Credential Sets Logic', () {
      test('Fails if credential_sets options is empty', () {
        final query = DcqlQuery()
          ..credentials.add(Credential(id: 'c1', format: Formats.mdoc))
          ..credentialSets = [CredentialSet(options: [])];

        final result = validator.validate(query);
        expect(result.isValid, isFalse);
        expect(result.contextPath, equals('query.credential_sets[0].options'));
        expect(
          result.errors?.first,
          contains('CredentialSet options cannot be an empty list'),
        );
      });

      test('Fails if credential_sets option is empty', () {
        final query = DcqlQuery()
          ..credentials.add(Credential(id: 'c1', format: Formats.mdoc))
          ..credentialSets = [
            CredentialSet(options: [[]]),
          ];

        final result = validator.validate(query);
        expect(result.isValid, isFalse);
        expect(
          result.contextPath,
          equals('query.credential_sets[0].options[0]'),
        );
        expect(
          result.errors?.first,
          contains('CredentialSet option cannot be an empty list'),
        );
      });

      test('Fails if credential set references unknown credential ID', () {
        final query = DcqlQuery()
          ..credentials.add(Credential(id: 'c1', format: Formats.mdoc))
          ..credentialSets = [
            CredentialSet(
              options: [
                ['c1'],
                ['unknown_c'],
              ],
            ),
          ];

        final result = validator.validate(query);
        expect(result.isValid, isFalse);
        expect(
          result.contextPath,
          equals('query.credential_sets[0].options[1][0]'),
        );
        expect(
          result.errors?.first,
          contains(
            'Credential ID "unknown_c" in credential set does not match any credential',
          ),
        );
      });
    });

    test('validateJson works correctly', () {
      final jsonString = '''
      {
        "credentials": [
          {
            "id": "c1",
            "format": "mso_mdoc"
          }
        ]
      }
      ''';
      final result = validator.validateJson(jsonString);
      expect(result.isValid, isTrue);
    });

    test('validateJson fails for invalid JSON', () {
      final jsonString = '''
      {
        "credentials": []
      }
      ''';
      final result = validator.validateJson(jsonString);
      expect(result.isValid, isFalse);
      expect(
        result.errors?.first,
        contains('DCQL query must contain at least one credential'),
      );
    });
  });

  group('ValidationResult & Exception', () {
    test('ValidationResult properties', () {
      final valid = ValidationResult.valid();
      expect(valid.isValid, isTrue);
      expect(valid.errors, isEmpty);
      expect(valid.contextPath, isNull);

      final invalid = ValidationResult.invalid(
        contextPath: 'path',
        errors: ['error'],
      );
      expect(invalid.isValid, isFalse);
      expect(invalid.errors, contains('error'));
      expect(invalid.contextPath, 'path');
    });

    test('ValidationException toString', () {
      final result = ValidationResult.invalid(errors: ['error']);
      final exception = ValidationException(result);
      expect(exception.toString(), contains('ValidationException'));
      expect(exception.toString(), contains('error'));
    });
  });
}
