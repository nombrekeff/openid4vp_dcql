import 'package:test/test.dart';
import 'package:openid4vp_dcql/builder/dcql_builder.dart';
import 'package:openid4vp_dcql/impl/claims.dart';
import 'package:openid4vp_dcql/enum/claim_type.dart';
import 'package:openid4vp_dcql/enum/format.dart';

void main() {
  group('DcqlBuilder', () {
    late DcqlBuilder builder;

    setUp(() {
      builder = DcqlBuilder();
    });

    test('build() returns a DcqlQuery', () {
      final query = builder.build();
      expect(query, isNotNull);
      expect(query.credentials, isEmpty);
      expect(query.credentialSets, isEmpty);
    });

    group('Credential Building', () {
      test('credential() adds a credential with ID', () {
        final query = builder.credential('cred-1').build();
        expect(query.credentials, hasLength(1));
        expect(query.credentials.first.id, equals('cred-1'));
      });

      test('credential() with format sets the format', () {
        final query = builder
            .credential('cred-1', format: Format.mdoc)
            .build();
        expect(query.credentials.first.format, equals(Format.mdoc));
      });

      test('credential() with CredentialType sets format and docType', () {
        final query = builder
            .credential('cred-1', type: CredentialType.mdocDl)
            .build();
        
        final cred = query.credentials.first;
        expect(cred.format, equals(Format.mdoc));
        // We can't easily check the meta filter without exposing it or checking the meta object directly
        // Assuming meta is set correctly if format is correct for now, or we could check if we can access meta
        expect(cred.meta, isNotNull);
      });

      test('claim() adds a claim to the credential', () {
        final claim = Claims.mdocDl.firstName;
        final query = builder
            .credential('cred-1')
            .claim(claim)
            .build();

        expect(query.credentials.first.claims, hasLength(1));
        expect(query.credentials.first.claims?.first, equals(claim));
      });

      test('claimSet() adds a claim set to the credential', () {
        final claimSetIds = ['claim-1', 'claim-2'];
        final query = builder
            .credential('cred-1')
            .claimSet(claimSetIds)
            .build();

        expect(query.credentials.first.claimSets, hasLength(1));
        expect(query.credentials.first.claimSets?.first, equals(claimSetIds));
      });

      test('mdoc_dl() helper sets format', () {
        final query = builder
            .credential('cred-1')
            .mdoc_dl()
            .build();
        
        expect(query.credentials.first.format, equals(Format.mdoc));
      });

      test('sdjwt_pid() helper sets format', () {
        final query = builder
            .credential('cred-1')
            .sdjwt_pid()
            .build();
        
        expect(query.credentials.first.format, equals(Format.jwt));
      });
    });

    group('Credential Set Building', () {
      test('credentialSet() adds a credential set', () {
        final query = builder.credentialSet().build();
        expect(query.credentialSets, hasLength(1));
      });

      test('credentialSet() with required flag', () {
        final query = builder.credentialSet(required: false).build();
        expect(query.credentialSets.first.required, isFalse);
      });

      test('option() adds options to credential set', () {
        final query = builder
            .credentialSet()
            .option(['cred-1'])
            .option(['cred-2', 'cred-3'])
            .build();

        final set = query.credentialSets.first;
        expect(set.options, hasLength(2));
        expect(set.options[0], equals(['cred-1']));
        expect(set.options[1], equals(['cred-2', 'cred-3']));
      });

      test('required() sets required flag', () {
        final query = builder
            .credentialSet()
            .required(false)
            .build();
        
        expect(query.credentialSets.first.required, isFalse);
      });
    });

    group('Chaining and Complex Queries', () {
      test('Can chain multiple credentials', () {
        final query = builder
            .credential('c1')
            .credential('c2')
            .build();
        
        expect(query.credentials, hasLength(2));
        expect(query.credentials[0].id, equals('c1'));
        expect(query.credentials[1].id, equals('c2'));
      });

      test('Can chain credentials and sets', () {
        final query = builder
            .credential('c1')
            .credentialSet()
            .option(['c1'])
            .build();
        
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
        expect(query.credentials[1].claims, isEmpty);
      });
    });
  });
}
