/// Standard Claim Element IDs for the ISO 18013-5 mDL.
/// Namespace: org.iso.18013.5.1
class MdocDlClaims {
  const MdocDlClaims._();

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

/// Standard Claims for EUDI PID (Personal Identification Data).
/// Format: SD-JWT
class PidClaims {
  const PidClaims._();

  // --- 1. Mandatory Identity ---
  static const String familyName = 'family_name';
  static const String givenName = 'given_name';
  static const String birthDate = 'birth_date';
  static const String uniqueId = 'personal_administrative_number'; // National ID No.

  // --- 2. Address & Location ---
  /// Often a structured JSON object or a full string depending on implementation
  static const String residentAddress = 'resident_address';
  static const String residentStreet = 'resident_street';
  static const String residentCity = 'resident_city';
  static const String residentPostalCode = 'resident_postal_code';
  static const String residentCountry = 'resident_country';
  
  // --- 3. Demographics ---
  static const String gender = 'gender';
  static const String nationality = 'nationality';
  static const String birthPlace = 'birth_place';
  
  // --- 4. Document Metadata ---
  static const String issuanceDate = 'issuance_date';
  static const String expiryDate = 'expiry_date';
  static const String issuingAuthority = 'issuing_authority';
  static const String documentNumber = 'document_number';
  static const String issuingCountry = 'issuing_country';

  // --- 5. Biometrics ---
  static const String portrait = 'portrait'; // Base64 encoded image usually
}