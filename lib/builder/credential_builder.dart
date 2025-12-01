import 'package:openid4vp_dcql/builder/dcql_builder.dart';
import 'package:openid4vp_dcql/claim.dart';
import 'package:openid4vp_dcql/credential.dart';
import 'package:openid4vp_dcql/enum/credential_type.dart';
import 'package:openid4vp_dcql/extensions/meta_set_filter_extension.dart';
import 'package:openid4vp_dcql/impl/credential_types.dart';
import 'package:openid4vp_dcql/trusted_authorities.dart';

class DcqlCredentialBuilder extends DcqlBuilder {
  late final DcqlCredentialBuilder _credentialBuilder;
  final Credential _credential;

  DcqlCredentialBuilder(DcqlBuilder parent, this._credential)
      : super(query: parent.query, validator: parent.validator) {
    _credentialBuilder = this;
  }

  DcqlCredentialBuilder claim(Claim claim, {String? id}) {
    if (id != null) {
      _credential.addClaim(claim.copyWith(id: id));
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
    _credential.trustedAuthorities!.add(
      TrustedAuthority(type: type, values: values),
    );
    return _credentialBuilder;
  }

  DcqlCredentialBuilder requireBinding([bool required = true]) {
    _credential.requireCryptographicHolderBinding = required;
    return _credentialBuilder;
  }

  DcqlCredentialBuilder multiple([bool multiple = true]) {
    _credential.multiple = multiple;
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

  DcqlCredentialBuilder setCredential(CredentialType credentialType) {
    _credential.format = credentialType.format;
    _credential.meta.setFilter(credentialType);
    return _credentialBuilder;
  }

  DcqlCredentialBuilder mDL() {
    setCredential(CredentialTypes.mdocDl);
    return _credentialBuilder;
  }

  DcqlCredentialBuilder jwtPid() {
    setCredential(CredentialTypes.sdJwtPid);
    return _credentialBuilder;
  }

  DcqlCredentialBuilder mVRC() {
    setCredential(CredentialTypes.mdocMvrc);
    return _credentialBuilder;
  }

  @override
  DcqlCredentialBuilder get $_ => this;
}
