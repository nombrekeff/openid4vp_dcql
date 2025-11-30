import 'package:openid4vp_dcql/enum/doc_type.dart';
import 'package:openid4vp_dcql/enum/format.dart';
import 'package:openid4vp_dcql/impl/formats.dart';
import 'package:openid4vp_dcql/json.dart';

class CredentialType with JsonSerializable {
  final Format format;
  final String docType;

  const CredentialType({required this.format, required this.docType});

  static const mdocDl = CredentialType(
    format: Formats.mdoc,
    docType: DocType.mDocMobileDrivingLicense,
  );

  static const mdocMvrc = CredentialType(
    format: Formats.mdoc,
    docType: DocType.mDocMobileVehicleRegistration,
  );

  static const sdJwtPid = CredentialType(
    format: Formats.jwt,
    docType: DocType.pidEuOfficial, // e.g., Personal Identity Document
  );

  @override
  String toString() {
    return 'CredentialType(format: ${format.name}, docType: $docType)';
  }

  @override
  toJson() {
    return {'format': format.name, 'doc_type': docType};
  }
}
