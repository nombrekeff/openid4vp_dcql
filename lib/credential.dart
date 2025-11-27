import 'package:openid4vp_dcql/claim.dart';
import 'package:openid4vp_dcql/enum/format.dart';
import 'package:openid4vp_dcql/meta.dart';

abstract class Credential<C extends Claim> {
  final String id;
  final Meta meta;
  final Format format;
  final List<C> claims;

  Credential({
    required this.id,
    required this.format,
    this.meta = const Meta(),
    this.claims = const [],
  });

  /// Adds a claim to the credential and returns the updated credential.
  Credential<C> addClaim(C claim) {
    claims.add(claim);
    return this;
  }

  /// Removes a claim from the credential and returns the updated credential.
  Credential<C> removeClaim(C claim) {
    claims.remove(claim);
    return this;
  }

  static MdocCredential mdoc({
    required String id,
    Meta meta = const Meta(),
    List<MdocClaim> claims = const [],
  }) => MdocCredential(id: id, meta: meta, claims: claims);

  static MdocCredential sdJwt({
    required String id,
    Meta meta = const Meta(),
    List<MdocClaim> claims = const [],
  }) => MdocCredential(id: id, meta: meta, claims: claims);
}

class MdocCredential extends Credential<MdocClaim> {
  MdocCredential({required super.id, super.meta, super.claims = const []})
    : super(format: Format.mdoc);
}

class SdJwtCredential extends Credential<Claim> {
  SdJwtCredential({required super.id, super.meta, super.claims = const []})
    : super(format: Format.jwt);
}
