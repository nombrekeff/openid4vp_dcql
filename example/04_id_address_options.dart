import 'dart:convert';

import 'package:openid4vp_dcql/builder/dcql_builder.dart';
import 'package:openid4vp_dcql/model/claim.dart';
import 'package:openid4vp_dcql/impl/claims.dart';
import 'package:openid4vp_dcql/impl/formats.dart';

/// Example 4: ID and Address from mDL or PhotoID
/// An ID and an address are requested; either can come from an mDL or a photoid Credential.
void main() {
  // https://openid.net/specs/openid-4-verifiable-presentations-1_0.html#appendix-D-8
  final query = DcqlBuilder()
      .credential('mdl-id', format: Formats.mdoc)
      .meta('doctype_value', 'org.iso.18013.5.1.mDL')
      .claim(Claims.mdocDl.givenName, id: 'given_name')
      .claim(Claims.mdocDl.familyName, id: 'family_name')
      .claim(Claims.mdocDl.portrait, id: 'portrait')
      .$_
      .credential('mdl-address', format: Formats.mdoc)
      .meta('doctype_value', 'org.iso.18013.5.1.mDL')
      .claim(Claims.mdocDl.residentAddress, id: 'resident_address')
      .claim(Claim(id: 'resident_country', path: ['org.iso.18013.5.1', 'resident_country']))
      .$_
      .credential('photo_card-id', format: Formats.mdoc)
      .meta('doctype_value', 'org.iso.23220.photoid.1')
      .claim(Claims.mdocDl.givenName, id: 'given_name')
      .claim(Claims.mdocDl.familyName, id: 'family_name')
      .claim(Claims.mdocDl.portrait, id: 'portrait')
      .$_
      .credential('photo_card-address', format: Formats.mdoc)
      .meta('doctype_value', 'org.iso.23220.photoid.1')
      .claim(Claims.mdocDl.residentAddress, id: 'resident_address')
      .claim(Claim(id: 'resident_country', path: ['org.iso.18013.5.1', 'resident_country']))
      .$_
      .credentialSet()
      .option(['mdl-id'])
      .option(['photo_card-id'])
      .$_
      .credentialSet(required: false)
      .option(['mdl-address'])
      .option(['photo_card-address'])
      .build();

  print('Example 4 (ID/Address options): $query');
  print('JSON: ${jsonEncode(query.toJson())}');
}
