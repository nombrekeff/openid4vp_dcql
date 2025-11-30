import 'package:openid4vp_dcql/enum/doc_type.dart';

abstract class DocTypes {
  // ISO mDoc
  /// https://credentials.walt.id/iso-mdoc-credentials/mdl-mobile-driving-licence
  static const mDocMobileDrivingLicense = DocType('org.iso.18013.5.1.mDL');

  /// https://credentials.walt.id/iso-mdoc-credentials/mvrc-mobile-vehicle-registration
  static const mDocMobileVehicleRegistration = DocType('org.iso.7367.1.mVRC');

  // EUDI ARF (The "Long" Form)
  static const pidEuOfficial = DocType('urn:eu.europa.ec.eudi.pid.1');
  static const ageOver18 = DocType('urn:eu.europa.ec.eudi.pseudonym.age_over_18.1');
  
  // PILOT / IMPLEMENTATION VARIANTS

  /// The shortened PID VCT used in many reference implementations and pilots.
  /// (This matches your working example)
  static const pidPilot = DocType('urn:eudi:pid:1');

  /// Common variation seen in German pilots
  static const pidDe = DocType('urn:eudi:pid:de:1');

  /// Common variation seen in Dutch pilots
  static const pidNl = DocType('nl.rdw.mech.1');
}
