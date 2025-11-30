import 'package:openid4vp_dcql/openid4vp_dcql.dart';

/// Class for holding format / doctype relationships
class CredentialType with JsonSerializable {
  final Format format;
  final DocType docType;

  const CredentialType({required this.format, required this.docType});

  @override
  String toString() {
    return 'CredentialType(format: ${format.name}, docType: $docType)';
  }

  @override
  toJson() {
    return {'format': format.name, 'doc_type': docType.id};
  }
}
