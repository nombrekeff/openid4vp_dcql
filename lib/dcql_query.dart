import 'package:openid4vp_dcql/credential.dart';
import 'package:openid4vp_dcql/credential_set.dart';
import 'package:openid4vp_dcql/json.dart';

/// Represents a DCQL (Digital Credentials Query Language) query.
///
/// A DCQL query is used to request specific credentials and claims from a wallet.
/// It consists of a list of [credentials] and optional [credentialSets] that define
/// the logic for satisfying the query.
class DcqlQuery with JsonSerializable {
  /// A list of credentials to request.
  final List<Credential> credentials;

  /// A list of credential sets that define combinations of credentials that satisfy the query.
  ///
  /// If null or empty, all credentials in [credentials] are required.
  List<CredentialSet>? credentialSets;

  DcqlQuery({List<Credential>? credentials, this.credentialSets})
      : credentials = credentials ?? [];

  /// Adds a [credential] to the query.
  DcqlQuery addCredential(Credential credential) {
    credentials.add(credential);
    return this;
  }

  /// Adds a [credentialSet] to the query.
  DcqlQuery addCredentialSet(CredentialSet credentialSet) {
    credentialSets ??= [];
    credentialSets?.add(credentialSet);
    return this;
  }

  /// Removes a [credential] from the query.
  ///
  /// Returns `true` if the credential was in the list, `false` otherwise.
  bool removeCredential(Credential credential) {
    return credentials.remove(credential);
  }

  /// Removes a [credentialSet] from the query.
  ///
  /// Returns `true` if the credential set was in the list, `false` otherwise.
  bool removeCredentialSet(CredentialSet credentialSet) {
    return credentialSets?.remove(credentialSet) ?? false;
  }

  @override
  String toString() {
    return 'DcqlQuery(credentials: $credentials, credentialSets: $credentialSets)';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'credentials': credentials.map((c) => c.toJson()).toList(),
      if (credentialSets != null)
        'credential_sets': credentialSets?.map((cs) => cs.toJson()).toList(),
    };
  }

  static DcqlQuery fromJson(Map<String, dynamic> json) {
    return DcqlQuery(
      credentials: (json['credentials'] as List<dynamic>?)
          ?.map((c) => Credential.fromJson(c as Map<String, dynamic>))
          .toList(),
      credentialSets: (json['credential_sets'] as List<dynamic>?)
          ?.map((cs) => CredentialSet.fromJson(cs as Map<String, dynamic>))
          .toList(),
    );
  }
}
