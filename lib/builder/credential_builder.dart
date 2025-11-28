import 'package:openid4vp_dcql/builder/dcql_builder.dart';
import 'package:openid4vp_dcql/claim.dart';
import 'package:openid4vp_dcql/credential.dart';
import 'package:openid4vp_dcql/enum/doc_type.dart';
import 'package:openid4vp_dcql/enum/format.dart';
import 'package:openid4vp_dcql/extensions/mdoc_meta.extension.dart';

class DcqlCredentialBuilder extends DcqlBuilder {
  late final DcqlCredentialBuilder _credentialBuilder;
  final Credential _credential;

  DcqlCredentialBuilder(DcqlBuilder parent, this._credential) : super(parent.query) {
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
