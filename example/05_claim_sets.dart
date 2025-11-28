import 'dart:convert';

import 'package:openid4vp_dcql/builder/dcql_builder.dart';
import 'package:openid4vp_dcql/claim.dart';
import 'package:openid4vp_dcql/enum/format.dart';

/// Example 5: Claim Sets (intra-credential options)
/// Requests mandatory claims last_name and date_of_birth, and
/// either postal_code, or (locality and region).
void main() {
  // https://openid.net/specs/openid-4-verifiable-presentations-1_0.html#appendix-D-11
  final query = DcqlBuilder()
      .credential('pid', format: Format.sd_jwt)
      .meta('vct_values', ['https://credentials.example.com/identity_credential'])
      .claim(Claim(id: 'a', path: ['last_name']))
      .claim(Claim(id: 'b', path: ['postal_code']))
      .claim(Claim(id: 'c', path: ['locality']))
      .claim(Claim(id: 'd', path: ['region']))
      .claim(Claim(id: 'e', path: ['date_of_birth']))
      .claimSet(['a', 'c', 'd', 'e'])
      .claimSet(['a', 'b', 'e'])
      .build();

  print('Example 5 (Claim Sets): $query');
  print('JSON: ${jsonEncode(query.toJson())}');
}
