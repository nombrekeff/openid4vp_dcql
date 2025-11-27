import 'package:openid4vp_dcql/credential.dart';
import 'package:openid4vp_dcql/credential_set.dart';
import 'package:openid4vp_dcql/dcql_query.dart';
import 'package:openid4vp_dcql/enum/doc_type.dart';
import 'package:openid4vp_dcql/openid4vp_dcql.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    var query = DcqlQuery(
      credentials: [
        Credential.mdoc(id: 'example-id')
      ],
      credentialSets: [CredentialSet()],
    );
  });

  Credential.mdoc(id: 'example-id');
}
