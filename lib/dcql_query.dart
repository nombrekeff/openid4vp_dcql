import 'package:openid4vp_dcql/credential.dart';
import 'package:openid4vp_dcql/credential_set.dart';

/// Represents a DCQL (Digital Credentials Query Language) query.
class DcqlQuery {
  final List<Credential> credentials;
  final List<CredentialSet> credentialSets;

  DcqlQuery({
     List<Credential>? credentials,
     List<CredentialSet>? credentialSets,
  }) : credentials = credentials ?? [],
       credentialSets = credentialSets ?? [];
}
