import 'package:openid4vp_dcql/openid4vp_dcql.dart';
import 'package:test/test.dart';

void main() {
  group('FromJson Graceful Failure', () {
    test('DcqlQuery.fromJson throws TypeError on invalid credentials type', () {
      final json = {
        'credentials': 'not_a_list',
      };
      expect(() => DcqlQuery.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('DcqlQuery.fromJson throws TypeError on invalid credential_sets type', () {
      final json = {
        'credentials': [],
        'credential_sets': 'not_a_list',
      };
      expect(() => DcqlQuery.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('Credential.fromJson throws TypeError on missing id', () {
      final json = {
        'format': 'mso_mdoc',
      };
      expect(() => Credential.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('Credential.fromJson throws TypeError on invalid claims type', () {
      final json = {
        'id': 'c1',
        'claims': 'not_a_list',
      };
      expect(() => Credential.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('Claim.fromJson throws TypeError on missing path', () {
      final json = {
        'id': 'claim1',
      };
      expect(() => Claim.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('Claim.fromJson throws TypeError on invalid path type', () {
      final json = {
        'id': 'claim1',
        'path': 'not_a_list',
      };
      expect(() => Claim.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('CredentialSet.fromJson throws TypeError on invalid options type', () {
      final json = {
        'options': 'not_a_list',
      };
      expect(() => CredentialSet.fromJson(json), throwsA(isA<TypeError>()));
    });
  });

  group('Builder with fromJson', () {
    test('DcqlBuilder works with query from fromJson', () {
      final json = {
        'credentials': [
          {
            'id': 'c1',
            'format': 'mso_mdoc',
            'claims': [
              {
                'id': 'claim1',
                'path': ['name'],
              },
            ],
          },
        ],
      };
      final query = DcqlQuery.fromJson(json);
      final builder = DcqlBuilder(query: query);
      
      builder.credential('c2', type: CredentialTypes.sdJwtPid).claim(Claim(path: ['age']));
      
      final builtQuery = builder.build(skipValidation: true);
      expect(builtQuery.credentials, hasLength(2));
      expect(builtQuery.credentials[0].id, 'c1');
      expect(builtQuery.credentials[1].id, 'c2');
    });
  });
}
