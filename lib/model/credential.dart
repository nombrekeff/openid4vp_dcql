import 'package:openid4vp_dcql/model/claim.dart';
import 'package:openid4vp_dcql/enum/format.dart';
import 'package:openid4vp_dcql/impl/formats.dart';
import 'package:openid4vp_dcql/json.dart';
import 'package:openid4vp_dcql/model/meta.dart';
import 'package:openid4vp_dcql/model/trusted_authorities.dart';

/// Represents a requested credential in a DCQL query.
///
/// See: https://openid.net/specs/openid-4-verifiable-presentations-1_0.html#name-credential-query
class Credential<C extends Claim> with JsonSerializable {
  /// A unique identifier for this credential query.
  ///
  /// This ID is used to reference the credential in [CredentialSet]s.
  String id;

  /// Metadata about the credential, such as the document type.
  Meta meta;

  /// Whether multiple credentials matching this query can be returned.
  bool? multiple;

  /// The format of the credential (e.g., mdoc, sd_jwt, etc.)
  /// Defaults to [Format.sd_jwt]
  Format format;

  /// A list of claims to request from the credential.
  List<C>? claims;

  /// A list of claim sets, where each claim set is a list of claim IDs.
  ///
  /// This defines which combinations of claims satisfy the requirement.
  List<List<String>>? claimSets;

  /// A list of trusted authorities (issuers) for this credential.
  List<TrustedAuthority>? trustedAuthorities;

  /// Whether cryptographic holder binding is required.
  bool? requireCryptographicHolderBinding;

  /// Format defaults to [Formats.sd_jwt]
  Credential({
    required this.id,
    this.format = Formats.sd_jwt,
    this.claimSets,
    this.multiple,
    Meta? meta,
    this.claims,
  }) : meta = meta ?? Meta();

  /// Adds a claim to the credential and returns the updated credential.
  Credential<C> addClaim(C claim) {
    claims ??= [];
    claims?.add(claim);
    return this;
  }

  /// Adds a claim set to the credential and returns the updated credential.
  Credential<C> addClaimSet(List<String> ids) {
    claimSets ??= [];
    claimSets!.add(ids);
    return this;
  }

  /// Removes a claim from the credential and returns the updated credential.
  Credential<C> removeClaim(C claim) {
    if (claims == null) return this;
    claims?.remove(claim);
    return this;
  }

  /// Removes a claim set from the credential and returns the updated credential.
  Credential<C> removeClaimSet(List<String> ids) {
    claimSets ??= [];
    claimSets!.removeWhere((claimSet) => claimSet == ids);
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'format': format.name,
      'meta': meta.toJson(),
      if (claims != null) 'claims': claims?.map((c) => c.toJson()).toList(),
      if (multiple != null) 'multiple': multiple,
      if (claimSets != null) 'claim_sets': claimSets,
    };
  }

  static Credential fromJson(Map<String, dynamic> c) {
    return Credential(
      id: c['id'] as String,
      format: Formats.values.firstWhere(
        (f) => f.name == (c['format'] as String),
        orElse: () => Formats.sd_jwt,
      ),
      meta: Meta.fromJson(c['meta'] as Map<String, dynamic>? ?? {}),
      multiple: c['multiple'] as bool?,
      claims:
          (c['claims'] as List<dynamic>?)
                  ?.map((claim) => Claim.fromJson(claim as Map<String, dynamic>))
                  .toList(),
      claimSets: (c['claim_sets'] as List<dynamic>?)
          ?.map((cs) => (cs as List<dynamic>).map((id) => id as String).toList())
          .toList(),
    );
  }
}
