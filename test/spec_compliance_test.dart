import 'package:openid4vp_dcql/openid4vp_dcql.dart';
import 'package:test/test.dart';

void main() {
  final validator = DcqlValidator();

  group('Spec Compliance', () {
    // Section 6.1. Credential Query
    // "The id MUST be a non-empty string consisting of alphanumeric, underscore (_), or hyphen (-) characters."
    test(
        'Credential ID MUST be non-empty string consisting of alphanumeric, underscore (_), or hyphen (-) characters',
        () {
      final validIds = ['valid', 'valid_id', 'valid-id', 'Valid123'];
      for (final id in validIds) {
        final query = DcqlQuery()
          ..credentials.add(Credential(id: id, format: Formats.mdoc));
        expect(
          validator.validate(query).isValid,
          isTrue,
          reason: 'ID "$id" should be valid',
        );
      }

      final invalidIds = ['', 'invalid id', 'invalid.id', 'invalid@id'];
      for (final id in invalidIds) {
        final query = DcqlQuery()
          ..credentials.add(Credential(id: id, format: Formats.mdoc));
        expect(
          validator.validate(query).isValid,
          isFalse,
          reason: 'ID "$id" should be invalid',
        );
      }
    });

    // Section 6.3. Claims Query
    // "The id MUST be a non-empty string consisting of alphanumeric, underscore (_), or hyphen (-) characters."
    test('Claim ID must be valid', () {
      final validIds = ['valid', 'valid_id', 'valid-id', 'Valid123'];
      for (final id in validIds) {
        final query = DcqlQuery()
          ..credentials.add(
            Credential(
              id: 'c1',
              format: Formats.mdoc,
              claims: [
                Claim(id: id, path: ['path']),
              ],
            ),
          );
        expect(
          validator.validate(query).isValid,
          isTrue,
          reason: 'Claim ID "$id" should be valid',
        );
      }

      final invalidIds = ['', 'invalid id', 'invalid.id', 'invalid@id'];
      for (final id in invalidIds) {
        final query = DcqlQuery()
          ..credentials.add(
            Credential(
              id: 'c1',
              format: Formats.mdoc,
              claims: [
                Claim(id: id, path: ['path']),
              ],
            ),
          );
        expect(
          validator.validate(query).isValid,
          isFalse,
          reason: 'Claim ID "$id" should be invalid',
        );
      }
    });

    // "Within the particular claims array, the same id MUST NOT be present more than once."
    test(
        'Within the particular claims array, the same id MUST NOT be present more than once',
        () {
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
      expect(validator.validate(query).isValid, isFalse);
    });

    // Section 6.4.1. Selecting Claims
    // "If claim_sets is present in the Credential Query, the id parameter in the Claims Query is REQUIRED."
    test(
        'If claim_sets is present, the id parameter in the Claims Query is REQUIRED',
        () {
      final query = DcqlQuery()
        ..credentials.add(
          Credential(
            id: 'c1',
            format: Formats.mdoc,
            claims: [
              Claim(path: ['path']),
            ], // Missing ID
            claimSets: [
              ['some_id'],
            ],
          ),
        );
      expect(validator.validate(query).isValid, isFalse);
    });
  });
}
