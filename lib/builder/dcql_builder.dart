import 'package:openid4vp_dcql/builder/credential_builder.dart';
import 'package:openid4vp_dcql/builder/credential_set_builder.dart';
import 'package:openid4vp_dcql/claim.dart';
import 'package:openid4vp_dcql/claims.dart';
import 'package:openid4vp_dcql/credential.dart';
import 'package:openid4vp_dcql/credential_set.dart';
import 'package:openid4vp_dcql/dcql_query.dart';
import 'package:openid4vp_dcql/enum/claim_type.dart';
import 'package:openid4vp_dcql/enum/doc_type.dart';
import 'package:openid4vp_dcql/enum/format.dart';
import 'package:openid4vp_dcql/extensions/mdoc_meta.extension.dart';

class DcqlBuilder {
  late final DcqlQuery _query;
  late final DcqlBuilder _dcqlBuilder;

  get query => _query;

  DcqlBuilder([DcqlQuery? query]) {
    _query = query ?? DcqlQuery();
    _dcqlBuilder = this;
  }

  DcqlCredentialBuilder credential(String id, {Format? format, CredentialType? type}) {
    final credential = Credential(id: id);

    if (type != null) {
      credential.format = type.format;
      credential.meta.setFilter(type.docType);
    } else if (format != null) {
      credential.format = format;
    }

    _query.credentials.add(credential);

    return DcqlCredentialBuilder(_dcqlBuilder, credential);
  }

  DcqlCredentialSetBuilder credentialSet({bool? required, List<List<String>>? options}) {
    final credentialSet = CredentialSet(required: required, options: options ?? []);
    _query.credentialSets.add(credentialSet);

    return DcqlCredentialSetBuilder(_dcqlBuilder, credentialSet);
  }

  DcqlQuery build() {
    // TODO: Do checks and validations here
    return _query;
  }

  DcqlBuilder get $_ => this;
}

void main() {
  final dcql = DcqlBuilder()
      .credential('credential-1', type: CredentialType.mdocDl)
      .claim(Claims.mdocDl.firstName)
      .$_
      .credential('credential-2', type: CredentialType.sdJwtPid)
      .claim(Claims.sdJwtPid.documentNumber)
      .$_
      .credential('credential-3', type: CredentialType.sdJwtPid)
      .claim(Claims.sdJwtPid.documentNumber)
      .$_
      .$_ // Either option 1 or option 2
      .credentialSet()
      .option(['credential-1'])
      .option(['credential-2'])
      .$_ // And option 3 if available
      .credentialSet(required: false)
      .option(['credential-3'])
      .build();
}
