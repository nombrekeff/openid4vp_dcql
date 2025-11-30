import 'dart:convert';

import 'package:openid4vp_dcql/builder/dcql_builder.dart';
import 'package:openid4vp_dcql/claim.dart';
import 'package:openid4vp_dcql/impl/claims.dart';
import 'package:openid4vp_dcql/enum/format.dart';

/// Example 3: Complex query with options
/// Wallet is requested to deliver the pid Credential, or the other_pid Credential,
/// or both pid_reduced_cred_1 and pid_reduced_cred_2.
/// Additionally, the nice_to_have Credential may optionally be delivered.
void main() {
  // https://openid.net/specs/openid-4-verifiable-presentations-1_0.html#appendix-D-6
  final query = DcqlBuilder()
      .credential('pid', format: Format.sd_jwt)
      .meta('vct_values', ['https://credentials.example.com/identity_credential'])
      .claim(Claims.sdJwtPid.givenName)
      .claim(Claims.sdJwtPid.familyName)
      .claim(Claim(path: ['address', 'street_address']))
      .$_
      .credential('other_pid', format: Format.sd_jwt)
      .meta('vct_values', ['https://othercredentials.example/pid'])
      .claim(Claims.sdJwtPid.givenName)
      .claim(Claims.sdJwtPid.familyName)
      .claim(Claim(path: ['address', 'street_address']))
      .$_
      .credential('pid_reduced_cred_1', format: Format.sd_jwt)
      .meta('vct_values', ['https://credentials.example.com/reduced_identity_credential'])
      .claim(Claims.sdJwtPid.familyName)
      .claim(Claims.sdJwtPid.givenName)
      .$_
      .credential('pid_reduced_cred_2', format: Format.sd_jwt)
      .meta('vct_values', ['https://cred.example/residence_credential'])
      .claim(Claim(path: ['postal_code']))
      .claim(Claim(path: ['locality']))
      .claim(Claim(path: ['region']))
      .$_
      .credential('nice_to_have', format: Format.sd_jwt)
      .meta('vct_values', ['https://company.example/company_rewards'])
      .claim(Claim(path: ['rewards_number']))
      .$_
      .credentialSet()
      .option(['pid'])
      .option(['other_pid'])
      .option(['pid_reduced_cred_1', 'pid_reduced_cred_2'])
      .$_
      .credentialSet(required: false)
      .option(['nice_to_have'])
      .build();

  print('Example 3 (Complex options): $query');
  print('JSON: ${jsonEncode(query.toJson())}');
}
