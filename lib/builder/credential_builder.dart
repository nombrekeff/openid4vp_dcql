import 'package:openid4vp_dcql/builder/dcql_builder.dart';
import 'package:openid4vp_dcql/claim.dart';
import 'package:openid4vp_dcql/credential.dart';
import 'package:openid4vp_dcql/enum/doc_type.dart';
import 'package:openid4vp_dcql/enum/format.dart';
import 'package:openid4vp_dcql/extensions/mdoc_meta.extension.dart';
import 'package:openid4vp_dcql/trusted_authorities.dart';

class DcqlCredentialBuilder extends DcqlBuilder {
  late final DcqlCredentialBuilder _credentialBuilder;
  final Credential _credential;

  DcqlCredentialBuilder(DcqlBuilder parent, this._credential) : super(parent.query) {
    _credentialBuilder = this;
  }

  DcqlCredentialBuilder claim(Claim claim, {String? id}) {
    if (id != null) {
      final newClaim = Claim(id: id, path: claim.path, values: claim.values);
      _credential.addClaim(newClaim);
    } else {
      _credential.addClaim(claim);
    }

    return _credentialBuilder;
  }

  DcqlCredentialBuilder meta(String key, dynamic value) {
    _credential.meta.set(key, value);
    return _credentialBuilder;
  }

  DcqlCredentialBuilder trustedAuthority(String type, List<String> values) {
    _credential.trustedAuthorities ??= [];
    _credential.trustedAuthorities!.add(TrustedAuthority(type: type, values: values));
    return _credentialBuilder;
  }

  DcqlCredentialBuilder requireBinding([bool required = true]) {
    _credential.requireCryptographicHolderBinding = required;
    return _credentialBuilder;
  }

  /// https://openid.net/specs/openid-4-verifiable-presentations-1_0.html#name-credential-set-query
  DcqlCredentialBuilder claimSet(List<String> ids) {
    if (_credential.claims == null || _credential.claims!.isEmpty) {
      throw Exception('Cannot add claim set to credential without claims.');
    }

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
