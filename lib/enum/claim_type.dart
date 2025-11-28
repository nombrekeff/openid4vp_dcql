import 'package:openid4vp_dcql/enum/doc_type.dart';
import 'package:openid4vp_dcql/enum/format.dart';
import 'package:openid4vp_dcql/json.dart';

class CredentialType with JsonSerializable {
  final Format format;
  final String docType;

  const CredentialType({required this.format, required this.docType});

  static const mdocDl = CredentialType(
    format: Format.mdoc,
    docType: DocType.mDocMobileDrivingLicense,
  );

  static const mdocMvrc = CredentialType(
    format: Format.mdoc,
    docType: DocType.mDocMobileVehicleRegistration,
  );

  static const sdJwtPid = CredentialType(
    format: Format.jwt,
    docType: DocType.pidEuOfficial, // e.g., Personal Identity Document
  );

  @override
  toJson() {
    return {'format': format.name, 'doc_type': docType};
  }
}
