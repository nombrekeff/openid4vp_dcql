import 'package:openid4vp_dcql/impl/formats.dart';
import 'package:openid4vp_dcql/openid4vp_dcql.dart';
import 'package:test/test.dart';

void main() {
  group('DcqlQuery', () {
    test('toJson and fromJson work correctly', () {
      final query = DcqlQuery()
        ..addCredential(Credential(id: 'c1', format: Formats.mdoc))
        ..addCredentialSet(
          CredentialSet(
            options: [
              ['c1'],
            ],
          ),
        );

      final json = query.toJson();
      expect(json['credentials'], hasLength(1));
      expect(json['credential_sets'], hasLength(1));

      final fromJson = DcqlQuery.fromJson(json);
      expect(fromJson.credentials, hasLength(1));
      expect(fromJson.credentials.first.id, 'c1');
      expect(fromJson.credentialSets, hasLength(1));
      expect(fromJson.credentialSets!.first.options.first.first, 'c1');
    });

    test('removeCredential works', () {
      final c1 = Credential(id: 'c1');
      final query = DcqlQuery()..addCredential(c1);
      expect(query.credentials, contains(c1));

      final removed = query.removeCredential(c1);
      expect(removed, isTrue);
      expect(query.credentials, isEmpty);
    });

    test('removeCredentialSet works', () {
      final cs1 = CredentialSet(options: []);
      final query = DcqlQuery()..addCredentialSet(cs1);
      expect(query.credentialSets, contains(cs1));

      final removed = query.removeCredentialSet(cs1);
      expect(removed, isTrue);
      expect(query.credentialSets, isEmpty);
    });

    test('removeCredentialSet returns false if set not found', () {
      final query = DcqlQuery();
      final cs1 = CredentialSet(options: []);
      final removed = query.removeCredentialSet(cs1);
      expect(removed, isFalse);
    });

    test('toString returns expected string', () {
      final query = DcqlQuery();
      expect(query.toString(), contains('DcqlQuery'));
    });
  });

  group('Credential', () {
    test('toJson and fromJson work correctly', () {
      final credential = Credential(
        id: 'c1',
        format: Formats.mdoc,
        multiple: true,
        meta: Meta()..set('doctype_value', 'org.iso.18013.5.1.mDL'),
        claims: [
          Claim(path: ['name'], id: 'claim1'),
        ],
        claimSets: [
          ['claim1'],
        ],
      );

      final json = credential.toJson();
      expect(json['id'], 'c1');
      expect(json['format'], 'mso_mdoc');
      expect(json['multiple'], true);
      expect(json['meta'], isNotEmpty);
      expect(json['claims'], hasLength(1));
      expect(json['claimSets'], hasLength(1));

      final fromJson = Credential.fromJson(json);
      expect(fromJson.id, 'c1');
      expect(fromJson.format, Formats.mdoc);
      expect(fromJson.multiple, true);
      expect(fromJson.meta.toJson(), equals(credential.meta.toJson()));
      expect(fromJson.claims, hasLength(1));
      expect(fromJson.claims!.first.path, equals(['name']));
      expect(fromJson.claimSets, hasLength(1));
      expect(fromJson.claimSets!.first, equals(['claim1']));
    });

    test('addClaim adds a claim', () {
      final credential = Credential(id: 'c1');
      final claim = Claim(path: ['name']);
      credential.addClaim(claim);
      expect(credential.claims, contains(claim));
    });

    test('removeClaim removes a claim', () {
      final credential = Credential(id: 'c1');
      final claim = Claim(path: ['name']);
      credential.addClaim(claim);
      credential.removeClaim(claim);
      expect(credential.claims, isEmpty);
    });

    test('removeClaim does nothing if claims is null', () {
      final credential = Credential(id: 'c1');
      final claim = Claim(path: ['name']);
      credential.removeClaim(claim);
      expect(credential.claims, isNull);
    });

    test('addClaimSet adds a claim set', () {
      final credential = Credential(id: 'c1');
      final claimSet = ['claim1'];
      credential.addClaimSet(claimSet);
      expect(credential.claimSets, contains(claimSet));
    });

    test('removeClaimSet removes a claim set', () {
      final credential = Credential(id: 'c1');
      final claimSet = ['claim1'];
      credential.addClaimSet(claimSet);
      credential.removeClaimSet(claimSet);
      expect(credential.claimSets, isEmpty);
    });
  });

  group('CredentialSet', () {
    test('toJson and fromJson work correctly', () {
      final credentialSet = CredentialSet(
        required: true,
        options: [
          ['c1'],
        ],
      );

      final json = credentialSet.toJson();
      expect(json['required'], true);
      expect(json['options'], hasLength(1));

      final fromJson = CredentialSet.fromJson(json);
      expect(fromJson.required, true);
      expect(fromJson.options, hasLength(1));
      expect(fromJson.options.first, equals(['c1']));
    });
  });

  group('Meta', () {
    test('toJson and fromJson work correctly', () {
      final meta = Meta()..set('key', 'value');
      final json = meta.toJson();
      expect(json['key'], 'value');

      final fromJson = Meta.fromJson(json);
      expect(fromJson!.toJson(), equals(json));
    });

    test('setFilter sets doc_type', () {
      final meta = Meta();
      meta.setFilter('doctype');
      expect(meta.toJson()['doc_type'], 'doctype');
    });

    test('set sets key-value pair', () {
      final meta = Meta();
      meta.set('custom_key', 'custom_value');
      expect(meta.toJson()['custom_key'], 'custom_value');
    });

    test('get returns value for key', () {
      final meta = Meta()..set('key', 'value');
      final value = meta.get('key');
      expect(value, 'value');
    });

    test('clear removes all key-value pairs', () {
      final meta = Meta()..set('key', 'value');
      meta.clear();
      expect(meta.toJson(), isEmpty);
    });

    test('remove removes key-value pair', () {
      final meta = Meta()..set('key', 'value');
      meta.remove('key');
      expect(meta.toJson().containsKey('key'), isFalse);
    });

    test('fromJson returns Meta object', () {
      final meta = Meta.fromJson({});
      expect(meta, isNotNull);
      expect(meta!.toJson(), isEmpty);
    });
  });

  group('DcqlCredentialBuilder', () {
    test('meta() sets meta value', () {
      final builder = DcqlBuilder().credential('c1').meta('key', 'value');
      final query = builder.build();
      expect(query.credentials.first.meta.toJson()['key'], 'value');
    });

    test('trustedAuthority() adds trusted authority', () {
      final builder = DcqlBuilder().credential('c1').trustedAuthority('type', ['value']);
      final query = builder.build();
      expect(query.credentials.first.trustedAuthorities, hasLength(1));
      expect(query.credentials.first.trustedAuthorities!.first.type, 'type');
      expect(query.credentials.first.trustedAuthorities!.first.values, equals(['value']));
    });

    test('trustedAuth json serialization works', () {
      final authority = TrustedAuthority(type: 'type', values: ['value']);
      final json = authority.toJson();
      expect(json['type'], 'type');
      expect(json['values'], equals(['value']));

      final fromJson = TrustedAuthority.fromJson(json);
      expect(fromJson.type, 'type');
      expect(fromJson.values, equals(['value']));
    });

    test('claim() adds claim to credential', () {
      final claim = Claim(path: ['name'], id: 'claim1');
      final builder = DcqlBuilder().credential('c1').claim(claim);
      final query = builder.build();
      expect(query.credentials.first.claims, contains(claim));
    });

    test('claim() copyWith', () {
      final claim = Claim(path: ['name'], values: ['Alice']);
      final ccp = claim.copyWith(id: 'claim1', values: ['Bob']);
      expect(ccp.id, 'claim1');
      expect(ccp.path, equals(['name']));
      expect(ccp.values, equals(['Bob']));
    });

    test('requireBinding() sets requireCryptographicHolderBinding', () {
      final builder = DcqlBuilder().credential('c1').requireBinding(true);
      final query = builder.build();
      expect(query.credentials.first.requireCryptographicHolderBinding, isTrue);
    });

    test('multiple() sets multiple flag', () {
      final builder = DcqlBuilder().credential('c1').multiple(true);
      final query = builder.build();
      expect(query.credentials.first.multiple, isTrue);
    });

    test('claimSet() throws if no claims', () {
      expect(
        () => DcqlBuilder().credential('c1').claimSet(['c1']),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Cannot add claim set to credential without claims'),
          ),
        ),
      );
    });
  });

  group('Format enum', () {
    test('toString works correctly', () {
      expect(Formats.mdoc.toString(), 'mso_mdoc');
      expect(Formats.sd_jwt.toString(), 'dc+sd-jwt');
    });

    test('toJson works correctly', () {
      expect(Formats.mdoc.toJson(), 'mso_mdoc');
      expect(Formats.sd_jwt.toJson(), 'dc+sd-jwt');
    });
  });

  group('CredentialType enum', () {
    test('format works correctly', () {
      expect(CredentialType.mdocDl.format, Formats.mdoc);
      expect(CredentialType.sdJwtPid.format, Formats.jwt);
    });

    test('docType works correctly', () {
      expect(CredentialType.mdocDl.docType, 'org.iso.18013.5.1.mDL');
      expect(CredentialType.sdJwtPid.docType, 'urn:eu.europa.ec.eudi.pid.1');
    });

    test('toJson works correctly', () {
      expect(CredentialType.mdocDl.toJson(), {
        'format': 'mso_mdoc',
        'doc_type': 'org.iso.18013.5.1.mDL',
      });
      expect(CredentialType.sdJwtPid.toJson(), {
        'format': 'dc+sd-jwt',
        'doc_type': 'urn:eu.europa.ec.eudi.pid.1',
      });
    });

    test('toString', () {
      expect(CredentialType.mdocDl.toString(), 'CredentialType(format: mso_mdoc, docType: org.iso.18013.5.1.mDL)');
      expect(CredentialType.sdJwtPid.toString(), 'CredentialType(format: dc+sd-jwt, docType: urn:eu.europa.ec.eudi.pid.1)');
    });
  });
}
