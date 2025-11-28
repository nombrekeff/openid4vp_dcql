import 'package:openid4vp_dcql/credential.dart';
import 'package:openid4vp_dcql/credential_set.dart';
import 'package:openid4vp_dcql/json.dart';

/// Represents a DCQL (Digital Credentials Query Language) query.
class DcqlQuery with JsonSerializable {
  final List<Credential> credentials;
  final List<CredentialSet> credentialSets;

  DcqlQuery({List<Credential>? credentials, List<CredentialSet>? credentialSets})
    : credentials = credentials ?? [],
      credentialSets = credentialSets ?? [];

  DcqlQuery addCredential(Credential credential) {
    credentials.add(credential);
    return this;
  }

  DcqlQuery addCredentialSet(CredentialSet credentialSet) {
    credentialSets.add(credentialSet);
    return this;
  }

  bool removeCredential(Credential credential) {
    return credentials.remove(credential);
  }

  bool removeCredentialSet(CredentialSet credentialSet) {
    return credentialSets.remove(credentialSet);
  }

  @override
  String toString() {
    return 'DcqlQuery(credentials: $credentials, credentialSets: $credentialSets)';
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
