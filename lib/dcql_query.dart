import 'package:openid4vp_dcql/credential.dart';
import 'package:openid4vp_dcql/credential_set.dart';
import 'package:openid4vp_dcql/json.dart';

/// Represents a DCQL (Digital Credentials Query Language) query.
class DcqlQuery with JsonSerializable {
  final List<Credential> credentials;
  List<CredentialSet>? credentialSets;

  DcqlQuery({List<Credential>? credentials, this.credentialSets})
      : credentials = credentials ?? [];

  DcqlQuery addCredential(Credential credential) {
    credentials.add(credential);
    return this;
  }

  DcqlQuery addCredentialSet(CredentialSet credentialSet) {
    credentialSets ??= [];
    credentialSets?.add(credentialSet);
    return this;
  }

  bool removeCredential(Credential credential) {
    return credentials.remove(credential);
  }

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
