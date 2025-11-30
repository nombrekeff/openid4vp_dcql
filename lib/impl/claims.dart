import 'package:openid4vp_dcql/claim.dart';
import 'package:openid4vp_dcql/constants.dart';

const String mdocMdl = DcqlConstants.iso18013_5_1;
const String mdocMvrc = DcqlConstants.iso7367_1;

Claim mdocClaim({String? id, required String ns, required List<String> path}) {
  return Claim(id: id, path: [ns, ...path]);
}

Claim mdocDlClaim({String? id, required List<String> path}) {
  return mdocClaim(id: id, ns: mdocMdl, path: path);
}

Claim mdocMvrcClaim({String? id, required List<String> path}) {
  return mdocClaim(id: id, ns: mdocMvrc, path: path);
}

Claim claim({String? id, required List<String> path}) {
  return Claim(id: id, path: path);
}

class MdocDlClaims {
  //=================================================
  // Identity Data
  //=================================================

  final Claim familyName = mdocDlClaim(path: ['family_name']);
  final Claim firstName = mdocDlClaim(path: ['first_name']);
  final Claim givenName = mdocDlClaim(path: ['given_name']);
  final Claim birthDate = mdocDlClaim(path: ['birth_date']);

  /// ISO 5218 code (1=Male, 2=Female)
  final Claim sex = mdocDlClaim(path: ['sex']);
  final Claim height = mdocDlClaim(path: ['height']);
  final Claim weight = mdocDlClaim(path: ['weight']);
  final Claim eyeColor = mdocDlClaim(path: ['eye_color']);
  final Claim hairColor = mdocDlClaim(path: ['hair_color']);
  final Claim residentAddress = mdocDlClaim(path: ['resident_address']);
  final Claim placeOfBirth = mdocDlClaim(path: ['place_of_birth']);

  //=================================================
  // Personal Data
  //=================================================
  final Claim issueDate = mdocDlClaim(path: ['issue_date']);
  final Claim expiryDate = mdocDlClaim(path: ['expiry_date']);

  /// Alpha-2 code (e.g., 'ES')
  final Claim issuingCountry = mdocDlClaim(path: ['issuing_country']);
  final Claim issuingAuthority = mdocDlClaim(path: ['issuing_authority']);
  final Claim documentNumber = mdocDlClaim(path: ['document_number']);
  final Claim administrativeNumber = mdocDlClaim(path: ['administrative_number']);

  /// e.g. 'E' for Spain
  final Claim unDistinguishingSign = mdocDlClaim(path: ['un_distinguishing_sign']);

  //=================================================
  // Driving Data (Complex Objects)
  //=================================================

  /// Returns a list of vehicle categories (A, B, C...) the user can drive.
  final Claim drivingPrivileges = mdocDlClaim(path: ['driving_privileges']);

  //=================================================
  // Biometrics & Images
  //=================================================
  final Claim portrait = mdocDlClaim(path: ['portrait']);
  final Claim signature = mdocDlClaim(path: ['signature_usual_mark']);
  final Claim portraitCaptureDate = mdocDlClaim(path: ['portrait_capture_date']);

  //=================================================
  // Age Attestations (Privacy)
  //=================================================
  /// Boolean: True if user is > 18 (Calculated by Wallet, no DOB revealed)
  final Claim ageOver18 = mdocDlClaim(path: ['age_over_18']);
  final Claim ageOver21 = mdocDlClaim(path: ['age_over_21']);
  final Claim ageInYears = mdocDlClaim(path: ['age_in_years']);
  final Claim ageBirthYear = mdocDlClaim(path: ['age_birth_year']);
}

class MdocMvrcClaims extends MdocDlClaims {
  // == Registration Details ==
  final Claim registrationPlateNumber = mdocMvrcClaim(path: ['registration_plate_number']);

  // == Vehicle Identification ==

  final Claim vin = mdocMvrcClaim(path: ['vehicle_identification_number']);
  final Claim vehicleMake = mdocMvrcClaim(path: ['vehicle_make']);
  final Claim commercialName = mdocMvrcClaim(path: ['commercial_name']);
  final Claim vehicleCategory = mdocMvrcClaim(path: ['vehicle_category_code']);
  final Claim vehicleColor = mdocMvrcClaim(path: ['vehicle_color']);

  // == Technical Specs ==

  final Claim massInService = mdocMvrcClaim(path: ['mass_in_service']);
  final Claim maxPermissibleMass = mdocMvrcClaim(path: ['maximum_permissible_mass']);
  final Claim engineDisplacement = mdocMvrcClaim(path: ['engine_displacement']);
  final Claim maxNetPower = mdocMvrcClaim(path: ['max_net_power']);
  final Claim fuelType = mdocMvrcClaim(path: ['fuel_type']);
  final Claim seatingCapacity = mdocMvrcClaim(path: ['seating_capacity']);

  // == Ownership Link ==
  /// IMPORTANT: This is a complex object identifying the owner.
  /// However, the actual human name (family_name) usually lives
  /// in the borrowed 'org.iso.18013.5.1' namespace.
  final Claim vehicleHolder = mdocMvrcClaim(path: ['vehicle_holder']);
}

class MdocSdJwtPidClaims {
  //== Mandatory Identity ==
  final Claim familyName = claim(path: ['family_name']);
  final Claim firstName = claim(path: ['first_name']);
  final Claim givenName = claim(path: ['given_name']);
  final Claim birthDate = claim(path: ['birth_date']);

  //== Address & Location ==
  final Claim residentAddress = claim(path: ['resident_address']);
  final Claim residentStreet = claim(path: ['resident_street']);
  final Claim residentCity = claim(path: ['resident_city']);
  final Claim residentPostalCode = claim(path: ['resident_postal_code']);
  final Claim residentCountry = claim(path: ['resident_country']);

  //== Demographics ==
  final Claim gender = claim(path: ['gender']);
  final Claim nationality = claim(path: ['nationality']);
  final Claim birthPlace = claim(path: ['birth_place']);

  //== Document Metadata ==
  final Claim issuanceDate = claim(path: ['issuance_date']);
  final Claim expiryDate = claim(path: ['expiry_date']);
  final Claim issuingAuthority = claim(path: ['issuing_authority']);
  final Claim documentNumber = claim(path: ['document_number']);
  final Claim issuingCountry = claim(path: ['issuing_country']);

  //== Biometrics ==
  final Claim portrait = claim(path: ['portrait']); // Base64 encoded image usually
}

class Claims {
  static final MdocDlClaims mdocDl = MdocDlClaims();
  static final MdocMvrcClaims mdocMvrc = MdocMvrcClaims();
  static final MdocSdJwtPidClaims sdJwtPid = MdocSdJwtPidClaims();
}
