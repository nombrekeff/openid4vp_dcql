import 'package:openid4vp_dcql/builder/credential_builder.dart';
import 'package:openid4vp_dcql/builder/credential_set_builder.dart';
import 'package:openid4vp_dcql/credential.dart';
import 'package:openid4vp_dcql/credential_set.dart';
import 'package:openid4vp_dcql/dcql_query.dart';
import 'package:openid4vp_dcql/enum/claicredential_type.dart';
import 'package:openid4vp_dcql/enum/format.dart';
import 'package:openid4vp_dcql/extensions/mdoc_meta.extension.dart';

class DcqlBuilder {
  late final DcqlQuery _query;
  late final DcqlBuilder _dcqlBuilder;

  /// The DCQL query being built.
  DcqlQuery get query => _query;

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
    _query.credentialSets ??= [];
    _query.credentialSets!.add(credentialSet);

    return DcqlCredentialSetBuilder(_dcqlBuilder, credentialSet);
  }

  DcqlQuery build() {
    // TODO: Do checks and validations here
    return _query;
  }

  DcqlBuilder get $_ => this;
}
