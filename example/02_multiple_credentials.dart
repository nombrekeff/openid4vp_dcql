import 'dart:convert';

import 'package:openid4vp_dcql/builder/dcql_builder.dart';
import 'package:openid4vp_dcql/claim.dart';
import 'package:openid4vp_dcql/claims.dart';
import 'package:openid4vp_dcql/enum/format.dart';

/// Example 2: Multiple credentials (all required)
/// Requests multiple Verifiable Credentials; all of them must be returned.
void main() {
  // https://openid.net/specs/openid-4-verifiable-presentations-1_0.html#appendix-D-4
  final query = DcqlBuilder()
      .credential('pid', format: Format.sd_jwt) // dc+sd-jwt
      .meta('vct_values', ['https://credentials.example.com/identity_credential'])
      .claim(Claims.sdJwtPid.givenName)
      .claim(Claims.sdJwtPid.familyName)
      .claim(Claim(path: ['address', 'street_address']))
      .$_
      .credential('mdl', format: Format.mdoc)
      .meta('doctype_value', 'org.iso.7367.1.mVRC')
      .claim(Claims.mdocMvrc.vehicleHolder)
      .claim(Claims.mdocDl.firstName)
      .build();

  print('Example 2 (Multiple credentials): $query');
  print('JSON: ${jsonEncode(query.toJson())}');
}
