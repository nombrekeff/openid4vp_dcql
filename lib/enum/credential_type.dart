import 'package:openid4vp_dcql/enum/format.dart';
import 'package:openid4vp_dcql/json.dart';

class CredentialType with JsonSerializable {
  final Format format;
  final String docType;

  const CredentialType({required this.format, required this.docType});

  @override
  String toString() {
    return 'CredentialType(format: ${format.name}, docType: $docType)';
  }

  @override
  toJson() {
    return {'format': format.name, 'doc_type': docType};
  }
}
