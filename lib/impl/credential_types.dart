import 'package:openid4vp_dcql/enum/credential_type.dart';
import 'package:openid4vp_dcql/enum/doc_type.dart';
import 'package:openid4vp_dcql/impl/doc_types.dart';
import 'package:openid4vp_dcql/impl/formats.dart';

abstract class CredentialTypes {
  static const mdocDl = CredentialType(
    format: Formats.mdoc,
    docType: DocTypes.mDocMobileDrivingLicense,
  );

  static const mdocMvrc = CredentialType(
    format: Formats.mdoc,
    docType: DocTypes.mDocMobileVehicleRegistration,
  );

  static const sdJwtPid = CredentialType(
    format: Formats.jwt,
    docType: DocTypes.pidEuOfficial, // e.g., Personal Identity Document
  );
}
