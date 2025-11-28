// Represents a document type identifier used in verifiable credential requests.
//
// Use predefined constants for common document types, or create custom instances:
// ```dart
// DocType.mDocDriverLicense;
// DocType('org.iso.18013.5.1.mDL');
// ```
// Predefined document types include official standards and common pilot variations.
//
// See relevant standards for more details.
// - ISO/IEC 18013-5:2021 (mDoc)
// - EUDI Wallet Architecture and Reference Framework
// - IETF Draft for Selective Disclosure JWT VC
class DocType {
  // ==========================================
  // OFFICIAL STANDARDS (EC ARF / ISO)
  // ==========================================

  // ISO mDoc
  /// https://credentials.walt.id/iso-mdoc-credentials/mdl-mobile-driving-licence
  static const mDocMobileDrivingLicense = 'org.iso.18013.5.1.mDL';

  /// https://credentials.walt.id/iso-mdoc-credentials/mvrc-mobile-vehicle-registration
  static const mDocMobileVehicleRegistration = 'org.iso.7367.1.mVRC';

  // EUDI ARF (The "Long" Form)
  static const pidEuOfficial = 'urn:eu.europa.ec.eudi.pid.1';
  static const ageOver18 = 'urn:eu.europa.ec.eudi.pseudonym.age_over_18.1';

  // ==========================================
  // PILOT / IMPLEMENTATION VARIANTS
  // ==========================================

  /// The shortened PID VCT used in many reference implementations and pilots.
  /// (This matches your working example)
  static const pidPilot = 'urn:eudi:pid:1';

  /// Common variation seen in German pilots
  static const pidDe = 'urn:eudi:pid:de:1';

  /// Common variation seen in Dutch pilots
  static const pidNl = 'nl.rdw.mech.1';
}
