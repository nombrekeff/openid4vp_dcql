import 'dart:convert';

import 'package:openid4vp_dcql/impl/credential_types.dart';
import 'package:openid4vp_dcql/openid4vp_dcql.dart';

void main() {
  final dcql = DcqlBuilder()
      .$_ // I'm just a convenience to space things out!
      // Build credential 1 with claims and claim sets
      .credential('credential-1', type: CredentialTypes.mdocDl)
      // Add individual claims (notice we use claims for the mdocDl credential)
      .claim(Claims.mdocDl.firstName, id: 'first_name')
      .claim(Claims.mdocDl.givenName, id: 'given_name')
      .claim(Claims.mdocDl.documentNumber, id: 'doc_number')
      .claim(Claims.mdocDl.portrait, id: 'portrait')
      // Either of these claim sets can be used to satisfy the claims
      // Think of them as OR conditions within this credential
      .claimSet(["first_name", "given_name", "doc_number"])
      .claimSet(["first_name", "given_name", "portrait"])
      .$_
      // Here as the credential type is sdJwtPid, we use the claims for that type
      .credential('credential-2', type: CredentialTypes.sdJwtPid)
      .claim(Claims.sdJwtPid.documentNumber)
      .$_
      .credential('credential-3', type: CredentialTypes.sdJwtPid)
      .claim(Claims.sdJwtPid.documentNumber)
      .$_
      // For this set, either credential 1 or 2 is required
      // We want at least one of them to be present
      .credentialSet()
      .option(['credential-1'])
      .option(['credential-2'])
      .$_
      // Additionally, credential 3 is optional and would be nice to have if available
      .credentialSet(required: false)
      .option(['credential-3']);

  print(jsonEncode(dcql.build().toJson()));
}
