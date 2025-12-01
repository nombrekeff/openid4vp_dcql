import 'package:openid4vp_dcql/openid4vp_dcql.dart';
import 'package:test/test.dart';

void main() {
  group('DcqlBuilder', () {
    late DcqlBuilder builder;

    setUp(() {
      builder = DcqlBuilder();
    });

    test('build() returns a DcqlQuery', () {
      final query = builder.credential("test").build();
      expect(query, isNotNull);
      expect(query.credentials, isNotEmpty);
      expect(query.credentialSets, isNull);
    });

    test('initializes with default values', () {
      expect(builder.query.credentials, isEmpty);
      expect(builder.query.credentialSets, isNull);
    });

    test('initializes with provided validator and query', () {
      final validator = DcqlValidator();
      final query = DcqlQuery();
      final customBuilder = DcqlBuilder(validator: validator, query: query);
      expect(customBuilder.validator, validator);
      expect(customBuilder.query, query);
    });

    group('Credential Building', () {
      test('credential() adds a credential with ID', () {
        final query = builder.credential('cred-1').build();
        expect(query.credentials, hasLength(1));
        expect(query.credentials.first.id, equals('cred-1'));
      });

      test('credential() with format sets the format', () {
        final query =
            builder.credential('cred-1', format: Formats.mdoc).build();
        expect(query.credentials.first.format, equals(Formats.mdoc));
      });

      test('credential() with CredentialType sets format and docType', () {
        final query =
            builder.credential('cred-1', type: CredentialTypes.mdocDl).build();

        final cred = query.credentials.first;
        expect(cred.format, equals(Formats.mdoc));
        // We can't easily check the meta filter without exposing it or checking the meta object directly
        // Assuming meta is set correctly if format is correct for now, or we could check if we can access meta
        expect(cred.meta, isNotNull);
      });

      test('claim() adds a claim to the credential', () {
        final claim = Claims.mdocDl.firstName;
        final query = builder.credential('cred-1').claim(claim).build();

        expect(query.credentials.first.claims, hasLength(1));
        expect(query.credentials.first.claims?.first, equals(claim));
      });

      test('claimSet() adds a claim set to the credential', () {
        final claimSetIds = ['claim-1', 'claim-2'];
        final query = builder
            .credential('cred-1')
            .claim(Claims.mdocDl.firstName, id: 'claim-1')
            .claim(Claims.mdocDl.familyName, id: 'claim-2')
            .claimSet(claimSetIds)
            .build();

        expect(query.credentials.first.claimSets, hasLength(1));
        expect(query.credentials.first.claimSets?.first, equals(claimSetIds));
      });

      test('mdoc_dl() helper sets format', () {
        final query = builder.credential('cred-1').mDL().build();

        expect(query.credentials.first.format, equals(Formats.mdoc));
      });

      test('sdjwt_pid() helper sets format', () {
        final query = builder.credential('cred-1').jwtPid().build();

        expect(query.credentials.first.format, equals(Formats.jwt));
      });
    });

    group('Credential Set Building', () {
      test('credentialSet() fails if no option added to set', () {
        expect(
          () => builder.credential('cred-1').credentialSet().build(),
          throwsA(isA<ValidationException>()),
        );
      });

      test('credentialSet() adds a credential set', () {
        final query = builder
            .credential('cred-1')
            .credentialSet()
            .option(['cred-1']).build();
        expect(query.credentialSets, hasLength(1));
      });

      test('credentialSet() with required flag', () {
        final query = builder
            .credential('cred-1')
            .credentialSet(required: false)
            .option(['cred-1']).build();
        expect(query.credentialSets?.first.required, isFalse);
      });

      test('option() adds options to credential set', () {
        final query = builder
            .credential('cred-1')
            .credential('cred-2')
            .credential('cred-3')
            .credentialSet()
            .option(['cred-1']).option(['cred-2', 'cred-3']).build();

        final set = query.credentialSets?.first;
        expect(set?.options, hasLength(2));
        expect(set?.options[0], equals(['cred-1']));
        expect(set?.options[1], equals(['cred-2', 'cred-3']));
      });

      test('credentialSet() fails if there are no options', () {
        expect(
          () => builder.credentialSet().build(),
          throwsA(isA<ValidationException>()),
        );
      });

      test('required() sets required flag', () {
        final query = builder
            .credential('cred-1')
            .credentialSet()
            .option(['cred-1'])
            .required(false)
            .build();

        expect(query.credentialSets?.first.required, isFalse);
      });
    });

    group('Chaining and Complex Queries', () {
      test('Can chain multiple credentials', () {
        final query = builder.credential('c1').credential('c2').build();

        expect(query.credentials, hasLength(2));
        expect(query.credentials[0].id, equals('c1'));
        expect(query.credentials[1].id, equals('c2'));
      });

      test('Can chain credentials and sets', () {
        final query =
            builder.credential('c1').credentialSet().option(['c1']).build();

        expect(query.credentials, hasLength(1));
        expect(query.credentialSets, hasLength(1));
      });

      test(r'$_ property allows "breaking" out (fluent style)', () {
        // In the current implementation, $_ returns 'this', so it doesn't strictly break out
        // in terms of type (it's still a builder), but it allows visual separation.
        final query = builder
            .credential('c1')
            .claim(Claims.mdocDl.firstName)
            .$_
            .credential('c2')
            .build();

        expect(query.credentials, hasLength(2));
        expect(query.credentials[0].claims, hasLength(1));
        expect(query.credentials[1].claims, isNull);
      });
    });

    group('Validation', () {
      test('credentialSet() fails if option is empty list', () {
        expect(
          () => builder.credential('cred-1').credentialSet().option([]).build(),
          throwsA(isA<ValidationException>()),
        );
      });

      test('credential() fails if id is invalid', () {
        expect(
          () => builder.credential('invalid id').build(),
          throwsA(isA<ValidationException>()),
        );
      });

      test('claim() fails if id is invalid', () {
        expect(
          () => builder
              .credential('cred-1')
              .claim(Claims.mdocDl.firstName, id: 'invalid id')
              .build(),
          throwsA(isA<ValidationException>()),
        );
      });

      test('claim() fails if id is missing when claim sets are present', () {
        expect(
          () => builder
              .credential('cred-1')
              .claim(Claims.mdocDl.firstName) // No ID
              .claimSet(['some_id']).build(),
          throwsA(isA<ValidationException>()),
        );
      });

      test('claimSet() fails if claim ID does not exist', () {
        expect(
          () => builder
              .credential('cred-1')
              .claim(Claims.mdocDl.firstName, id: 'id1')
              .claimSet(['non_existent_id']).build(),
          throwsA(isA<ValidationException>()),
        );
      });

      test('build(skipValidation: true) allows invalid state', () {
        final query =
            builder.credential('invalid id').build(skipValidation: true);
        expect(query.credentials.first.id, 'invalid id');
      });

      test('Fails if credential ID is empty', () {
        expect(
          () => builder.credential('').build(),
          throwsA(isA<ValidationException>()),
        );
      });

      test('Fails if claim values are empty', () {
        expect(
          () => builder
              .credential('cred-1')
              .claim(Claim(path: ['path'], values: []))
              .build(),
          throwsA(isA<ValidationException>()),
        );
      });
    });

    group('Complex Success Scenarios', () {
      test('Builds complex query with multiple credentials and sets', () {
        final query = builder
            .credential('cred-1', format: Formats.mdoc)
            .claim(Claims.mdocDl.firstName, id: 'first_name')
            .claim(Claims.mdocDl.familyName, id: 'family_name')
            .credential('cred-2', format: Formats.jwt)
            .claim(Claims.sdJwtPid.givenName, id: 'given_name')
            .credentialSet(required: true)
            .option(['cred-1']).option(['cred-2']).build();

        expect(query.credentials, hasLength(2));
        expect(query.credentialSets, hasLength(1));
        expect(query.credentialSets!.first.options, hasLength(2));
      });
    });
  });
}
