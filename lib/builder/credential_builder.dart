import 'package:openid4vp_dcql/builder/dcql_builder.dart';
import 'package:openid4vp_dcql/model/claim.dart';
import 'package:openid4vp_dcql/model/credential.dart';
import 'package:openid4vp_dcql/enum/credential_type.dart';
import 'package:openid4vp_dcql/extensions/meta_set_filter_extension.dart';
import 'package:openid4vp_dcql/impl/credential_types.dart';
import 'package:openid4vp_dcql/model/trusted_authorities.dart';

class DcqlCredentialBuilder extends DcqlBuilder {
  late final DcqlCredentialBuilder _credentialBuilder;
  final Credential _credential;

  DcqlCredentialBuilder(DcqlBuilder parent, this._credential)
      : super(query: parent.query, validator: parent.validator) {
    _credentialBuilder = this;
  }

  /// Adds a claim to the credential.
  ///
  /// [claim] is the claim to add.
  /// [id] is an optional identifier for the claim, overriding the one in [claim].
  DcqlCredentialBuilder claim(Claim claim, {String? id}) {
    if (id != null) {
      _credential.addClaim(claim.copyWith(id: id));
    } else {
      _credential.addClaim(claim);
    }

    return _credentialBuilder;
  }

  /// Sets a metadata value for the credential.
  DcqlCredentialBuilder meta(String key, dynamic value) {
    _credential.meta.set(key, value);
    return _credentialBuilder;
  }

  /// Adds a trusted authority (issuer) for the credential.
  DcqlCredentialBuilder trustedAuthority(String type, List<String> values) {
    _credential.trustedAuthorities ??= [];
    _credential.trustedAuthorities!.add(
      TrustedAuthority(type: type, values: values),
    );
    return _credentialBuilder;
  }

  /// Sets whether cryptographic holder binding is required.
  DcqlCredentialBuilder requireBinding([bool required = true]) {
    _credential.requireCryptographicHolderBinding = required;
    return _credentialBuilder;
  }

  /// Sets whether multiple credentials matching this query can be returned.
  DcqlCredentialBuilder multiple([bool multiple = true]) {
    _credential.multiple = multiple;
    return _credentialBuilder;
  }

  /// Adds a claim set to the credential.
  ///
  /// [ids] is a list of claim IDs that form the set.
  /// Throws an exception if the credential has no claims.
  ///
  /// See: https://openid.net/specs/openid-4-verifiable-presentations-1_0.html#name-credential-set-query
  DcqlCredentialBuilder claimSet(List<String> ids) {
    if (_credential.claims == null || _credential.claims!.isEmpty) {
      throw Exception('Cannot add claim set to credential without claims.');
    }

    _credential.addClaimSet(ids);
    return _credentialBuilder;
  }

  /// Sets the credential type, updating the format and metadata filter.
  DcqlCredentialBuilder setCredential(CredentialType credentialType) {
    _credential.format = credentialType.format;
    _credential.meta.setFilter(credentialType);
    return _credentialBuilder;
  }

  /// Helper to set the credential type to mDoc Driving License.
  DcqlCredentialBuilder mDL() {
    setCredential(CredentialTypes.mdocDl);
    return _credentialBuilder;
  }

  /// Helper to set the credential type to SD-JWT PID.
  DcqlCredentialBuilder jwtPid() {
    setCredential(CredentialTypes.sdJwtPid);
    return _credentialBuilder;
  }

  /// Helper to set the credential type to mDoc mVRC.
  DcqlCredentialBuilder mVRC() {
    setCredential(CredentialTypes.mdocMvrc);
    return _credentialBuilder;
  }

  @override
  DcqlCredentialBuilder get $_ => this;
}
