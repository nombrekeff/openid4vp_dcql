/// Standard Claims for EUDI PID (Personal Identification Data).
/// Format: SD-JWT
class PidClaim {
  const PidClaim._();

  // --- 1. Mandatory Identity ---
  static const String familyName = 'family_name';
  static const String givenName = 'given_name';
  static const String birthDate = 'birth_date';
  // National ID No.
  static const String personalAdministrativeNumber =
      'personal_administrative_number';

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
