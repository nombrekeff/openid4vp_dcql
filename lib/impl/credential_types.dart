import 'package:openid4vp_dcql/enum/credential_type.dart';
import 'package:openid4vp_dcql/enum/doc_type.dart';
import 'package:openid4vp_dcql/impl/formats.dart';

abstract class CredentialTypes {
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
}
