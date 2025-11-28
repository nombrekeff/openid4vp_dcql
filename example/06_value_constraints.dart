import 'dart:convert';

import 'package:openid4vp_dcql/builder/dcql_builder.dart';
import 'package:openid4vp_dcql/claim.dart';
import 'package:openid4vp_dcql/enum/format.dart';

/// Example 6: Value Constraints
/// Requests a Credential with specific values for the last_name and postal_code claims.
void main() {
  // https://openid.net/specs/openid-4-verifiable-presentations-1_0.html#appendix-D-13
  final query = DcqlBuilder()
      .credential('my_credential', format: Format.sd_jwt)
      .meta('vct_values', ['https://credentials.example.com/identity_credential'])
      .claim(Claim(path: ['last_name'], values: ['Doe']))
      .claim(Claim(path: ['first_name']))
      .claim(Claim(path: ['address', 'street_address']))
      .claim(Claim(path: ['postal_code'], values: ['90210', '90211']))
      .build();

  print('Example 6 (Value Constraints): $query');
  print('JSON: ${jsonEncode(query.toJson())}');
}
