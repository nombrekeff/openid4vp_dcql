class DocTypes {
  const DocTypes._();

  // ==========================================
  // OFFICIAL STANDARDS (EC ARF / ISO)
  // ==========================================
  
  // ISO mDoc
  static const String mDocDriverLicense = 'org.iso.18013.5.1.mDL';
  static const String mDocMobileId      = 'org.iso.18013.7.1.mID';

  // EUDI ARF (The "Long" Form)
  static const String pidEuOfficial     = 'urn:eu.europa.ec.eudi.pid.1';
  static const String ageOver18         = 'urn:eu.europa.ec.eudi.pseudonym.age_over_18.1';

  // ==========================================
  // PILOT / IMPLEMENTATION VARIANTS
  // ==========================================
  
  /// The shortened PID VCT used in many reference implementations and pilots.
  /// (This matches your working example)
  static const String pidPilot          = 'urn:eudi:pid:1';

  /// Common variation seen in German pilots
  static const String pidDe             = 'urn:eudi:pid:de:1';

  /// Common variation seen in Dutch pilots
  static const String pidNl             = 'nl.rdw.mech.1'; 
}