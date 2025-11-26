/// Standard Claim Element IDs for the ISO 18013-5 mDL.
/// Namespace: org.iso.18013.5.1
class MdocDlClaim {
  const MdocDlClaim._();

  // --- 1. Identity Data ---
  static const String familyName = 'family_name';
  static const String givenName = 'given_name';
  static const String birthDate = 'birth_date';
  static const String sex = 'sex'; // ISO 5218 code (1=Male, 2=Female)
  static const String height = 'height'; // Int (cm)
  static const String weight = 'weight'; // Int (kg)
  static const String eyeColor = 'eye_color';
  static const String hairColor = 'hair_color';
  static const String residentAddress = 'resident_address';
  static const String placeOfBirth = 'place_of_birth'; // Optional in ISO

  // --- 2. Document Data ---
  static const String issueDate = 'issue_date';
  static const String expiryDate = 'expiry_date';
  static const String issuingCountry = 'issuing_country'; // Alpha-2 code (e.g., 'ES')
  static const String issuingAuthority = 'issuing_authority';
  static const String documentNumber = 'document_number';
  static const String administrativeNumber = 'administrative_number';
  static const String unDistinguishingSign = 'un_distinguishing_sign'; // e.g. 'E' for Spain

  // --- 3. Driving Data (Complex Objects) ---
  /// Returns a list of vehicle categories (A, B, C...) the user can drive.
  static const String drivingPrivileges = 'driving_privileges';

  // --- 4. Biometrics & Images ---
  static const String portrait = 'portrait'; // Byte array (JPEG/JP2)
  static const String signature = 'signature_usual_mark'; // Byte array
  static const String portraitCaptureDate = 'portrait_capture_date';

  // --- 5. Age Attestations (Privacy) ---
  /// Boolean: True if user is > 18 (Calculated by Wallet, no DOB revealed)
  static const String ageOver18 = 'age_over_18';
  static const String ageOver21 = 'age_over_21';
  static const String ageInYears = 'age_in_years'; // Just the number (e.g., 25)
  static const String ageBirthYear = 'age_birth_year'; // Just the year (e.g., 1999)
}
