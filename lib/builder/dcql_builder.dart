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

class DcqlCredentialBuilder extends DcqlBuilder {
  late final DcqlCredentialBuilder _credentialBuilder;
  final Credential _credential;

  DcqlCredentialBuilder(DcqlBuilder parent, this._credential) : super(parent._query) {
    _credentialBuilder = this;
  }

  DcqlCredentialBuilder claim(Claim claim, {String? id}) {
    _credential.addClaim(claim);

    return _credentialBuilder;
  }

  /// https://openid.net/specs/openid-4-verifiable-presentations-1_0.html#name-credential-set-query
  DcqlCredentialBuilder claimSet(List<String> ids) {
    _credential.addClaimSet(ids);
    return _credentialBuilder;
  }

  DcqlCredentialBuilder mdoc_dl() {
    _credential.format = Format.mdoc;
    _credential.meta.setFilter(DocType.mDocMobileDrivingLicense);
    // TODO: Add validator to ensure correct format?

    return _credentialBuilder;
  }

  DcqlCredentialBuilder sdjwt_pid() {
    _credential.format = Format.jwt;
    _credential.meta.setFilter(DocType.pidEuOfficial);
    // TODO: Add validator to ensure correct format?

    return _credentialBuilder;
  }

  @override
  DcqlCredentialBuilder get $_ => this;
}

class DcqlCredentialSetBuilder extends DcqlBuilder {
  late final DcqlCredentialSetBuilder _credentialSetBuilder;
  final CredentialSet _credentialSet;

  DcqlCredentialSetBuilder(DcqlBuilder parent, this._credentialSet) : super(parent._query) {
    _credentialSetBuilder = this;
  }

  DcqlCredentialSetBuilder option(List<String> option) {
    _credentialSet.options.add(option);
    return _credentialSetBuilder;
  }

  DcqlCredentialSetBuilder required([bool required = true]) {
    _credentialSet.required = required;
    return _credentialSetBuilder;
  }

  @override
  DcqlCredentialSetBuilder get $_ => this;
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
