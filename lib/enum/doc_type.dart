
/// Represents a document type identifier used in verifiable credential requests.
/// 
/// Use predefined constants for common document types, or create custom instances:
/// ```dart
/// DocType.mDocDriverLicense;
/// DocType('org.iso.18013.5.1.mDL');
/// ```
/// Predefined document types include official standards and common pilot variations.
/// 
/// See relevant standards for more details.
/// - ISO/IEC 18013-5:2021 (mDoc)
/// - EUDI Wallet Architecture and Reference Framework
/// - IETF Draft for Selective Disclosure JWT VC
class DocType {
  final String id;
  const DocType(this.id);

  // ==========================================
  // OFFICIAL STANDARDS (EC ARF / ISO)
  // ==========================================

  // ISO mDoc
  static const DocType mDocDriverLicense = DocType('org.iso.18013.5.1.mDL');
  static const DocType mDocMobileId = DocType('org.iso.18013.7.1.mID');

  // EUDI ARF (The "Long" Form)
  static const DocType pidEuOfficial = DocType('urn:eu.europa.ec.eudi.pid.1');
  static const DocType ageOver18 = DocType(
    'urn:eu.europa.ec.eudi.pseudonym.age_over_18.1',
  );

  // ==========================================
  // PILOT / IMPLEMENTATION VARIANTS
  // ==========================================

  /// The shortened PID VCT used in many reference implementations and pilots.
  /// (This matches your working example)
  static const DocType pidPilot = DocType('urn:eudi:pid:1');

  /// Common variation seen in German pilots
  static const DocType pidDe = DocType('urn:eudi:pid:de:1');

  /// Common variation seen in Dutch pilots
  static const DocType pidNl = DocType('nl.rdw.mech.1');
}
