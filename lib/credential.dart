import 'package:openid4vp_dcql/claim.dart';
import 'package:openid4vp_dcql/enum/format.dart';
import 'package:openid4vp_dcql/meta.dart';

/// https://openid.net/specs/openid-4-verifiable-presentations-1_0.html#name-credential-query
class Credential<C extends Claim> {
  String id;
  Meta meta;
  bool multiple;

  /// The format of the credential (e.g., mdoc, sd_jwt, etc.)
  /// Defaults to [Format.sd_jwt]
  Format format;
  List<C> claims;

  /// A list of claim sets, where each claim set is a list of claim IDs.
  List<List<String>> claimSets;

  /// Format defaults to [Format.sd_jwt]
  Credential({
    required this.id,
    this.format = Format.sd_jwt,
    Meta? meta,
    List<C>? claims,
    List<List<String>>? claimSets,
    this.multiple = false,
  }) : meta = meta ?? Meta(),
       claims = claims ?? [],
       claimSets = claimSets ?? [];

  /// Adds a claim to the credential and returns the updated credential.
  Credential<C> addClaim(C claim) {
    claims.add(claim);
    return this;
  }

  /// Adds a claim set to the credential and returns the updated credential.
  Credential<C> addClaimSet(List<String> ids) {
    claimSets.add(ids);
    return this;
  }

  /// Removes a claim from the credential and returns the updated credential.
  Credential<C> removeClaim(C claim) {
    claims.remove(claim);
    return this;
  }

  /// Removes a claim set from the credential and returns the updated credential.
  Credential<C> removeClaimSet(List<String> ids) {
    claimSets.removeWhere((claimSet) => claimSet == ids);
    return this;
  }
}
