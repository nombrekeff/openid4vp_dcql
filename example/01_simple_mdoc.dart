import 'dart:convert';

import 'package:openid4vp_dcql/builder/dcql_builder.dart';
import 'package:openid4vp_dcql/impl/claims.dart';
import 'package:openid4vp_dcql/impl/formats.dart';

/// Example 1: Simple mdoc query
/// Requests a Verifiable Credential in the format mso_mdoc with the claims vehicle_holder and first_name.
void main() {
  // {
  //   "credentials": [
  //     {
  //       "id": "my_credential",
  //       "format": "mso_mdoc",
  //       "meta": {
  //         "doctype_value": "org.iso.7367.1.mVRC"
  //       },
  //       "claims": [
  //         {"path": ["org.iso.7367.1", "vehicle_holder"]},
  //         {"path": ["org.iso.18013.5.1", "first_name"]}
  //       ]
  //     }
  //   ]
  // }
  final query = DcqlBuilder()
      .credential('my_credential', format: Formats.mdoc)
      .meta('doctype_value', 'org.iso.7367.1.mVRC')
      .claim(Claims.mdocMvrc.vehicleHolder)
      .claim(Claims.mdocDl.firstName)
      .build();

  print('Example 1 (Simple mdoc): $query');

  final encoder = JsonEncoder.withIndent('  ');
  print('JSON: ${encoder.convert(query.toJson())}');
}
