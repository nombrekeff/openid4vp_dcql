import 'package:test/test.dart';
import 'package:openid4vp_dcql/impl/claims.dart';

void main() {
  group('Claims Structure and Paths', () {
    group('MdocDlClaims', () {
      final claims = Claims.mdocDl;
      const ns = 'org.iso.18013.5.1';

      test('Identity Data paths are correct', () {
        expect(claims.familyName.path, equals([ns, 'family_name']));
        expect(claims.firstName.path, equals([ns, 'first_name']));
        expect(claims.givenName.path, equals([ns, 'given_name']));
        expect(claims.birthDate.path, equals([ns, 'birth_date']));
        expect(claims.sex.path, equals([ns, 'sex']));
        expect(claims.height.path, equals([ns, 'height']));
        expect(claims.weight.path, equals([ns, 'weight']));
        expect(claims.eyeColor.path, equals([ns, 'eye_color']));
        expect(claims.hairColor.path, equals([ns, 'hair_color']));
        expect(claims.residentAddress.path, equals([ns, 'resident_address']));
        expect(claims.placeOfBirth.path, equals([ns, 'place_of_birth']));
      });

      test('Personal Data paths are correct', () {
        expect(claims.issueDate.path, equals([ns, 'issue_date']));
        expect(claims.expiryDate.path, equals([ns, 'expiry_date']));
        expect(claims.issuingCountry.path, equals([ns, 'issuing_country']));
        expect(claims.issuingAuthority.path, equals([ns, 'issuing_authority']));
        expect(claims.documentNumber.path, equals([ns, 'document_number']));
        expect(claims.administrativeNumber.path, equals([ns, 'administrative_number']));
        expect(claims.unDistinguishingSign.path, equals([ns, 'un_distinguishing_sign']));
      });

      test('Driving Data paths are correct', () {
        expect(claims.drivingPrivileges.path, equals([ns, 'driving_privileges']));
      });

      test('Biometrics & Images paths are correct', () {
        expect(claims.portrait.path, equals([ns, 'portrait']));
        expect(claims.signature.path, equals([ns, 'signature_usual_mark']));
        expect(claims.portraitCaptureDate.path, equals([ns, 'portrait_capture_date']));
      });

      test('Age Attestations paths are correct', () {
        expect(claims.ageOver18.path, equals([ns, 'age_over_18']));
        expect(claims.ageOver21.path, equals([ns, 'age_over_21']));
        expect(claims.ageInYears.path, equals([ns, 'age_in_years']));
        expect(claims.ageBirthYear.path, equals([ns, 'age_birth_year']));
      });
    });

    group('MdocMvrcClaims', () {
      final claims = Claims.mdocMvrc;
      const ns = 'org.iso.7367.1';

      test('Registration Details paths are correct', () {
        expect(claims.registrationPlateNumber.path, equals([ns, 'registration_plate_number']));
      });

      test('Vehicle Identification paths are correct', () {
        expect(claims.vin.path, equals([ns, 'vehicle_identification_number']));
        expect(claims.vehicleMake.path, equals([ns, 'vehicle_make']));
        expect(claims.commercialName.path, equals([ns, 'commercial_name']));
        expect(claims.vehicleCategory.path, equals([ns, 'vehicle_category_code']));
        expect(claims.vehicleColor.path, equals([ns, 'vehicle_color']));
      });

      test('Technical Specs paths are correct', () {
        expect(claims.massInService.path, equals([ns, 'mass_in_service']));
        expect(claims.maxPermissibleMass.path, equals([ns, 'maximum_permissible_mass']));
        expect(claims.engineDisplacement.path, equals([ns, 'engine_displacement']));
        expect(claims.maxNetPower.path, equals([ns, 'max_net_power']));
        expect(claims.fuelType.path, equals([ns, 'fuel_type']));
        expect(claims.seatingCapacity.path, equals([ns, 'seating_capacity']));
      });

      test('Ownership Link paths are correct', () {
        expect(claims.vehicleHolder.path, equals([ns, 'vehicle_holder']));
      });

      test('Inherited DL claims retain DL namespace', () {
        // MdocMvrcClaims extends MdocDlClaims, so it has DL claims.
        // These should still have the DL namespace.
        const dlNs = 'org.iso.18013.5.1';
        expect(claims.familyName.path, equals([dlNs, 'family_name']));
      });
    });

    group('MdocSdJwtPidClaims', () {
      final claims = Claims.sdJwtPid;

      test('Mandatory Identity paths are correct', () {
        expect(claims.familyName.path, equals(['family_name']));
        expect(claims.firstName.path, equals(['first_name']));
        expect(claims.givenName.path, equals(['given_name']));
        expect(claims.birthDate.path, equals(['birth_date']));
      });

      test('Address & Location paths are correct', () {
        expect(claims.residentAddress.path, equals(['resident_address']));
        expect(claims.residentStreet.path, equals(['resident_street']));
        expect(claims.residentCity.path, equals(['resident_city']));
        expect(claims.residentPostalCode.path, equals(['resident_postal_code']));
        expect(claims.residentCountry.path, equals(['resident_country']));
      });

      test('Demographics paths are correct', () {
        expect(claims.gender.path, equals(['gender']));
        expect(claims.nationality.path, equals(['nationality']));
        expect(claims.birthPlace.path, equals(['birth_place']));
      });

      test('Document Metadata paths are correct', () {
        expect(claims.issuanceDate.path, equals(['issuance_date']));
        expect(claims.expiryDate.path, equals(['expiry_date']));
        expect(claims.issuingAuthority.path, equals(['issuing_authority']));
        expect(claims.documentNumber.path, equals(['document_number']));
        expect(claims.issuingCountry.path, equals(['issuing_country']));
      });

      test('Biometrics paths are correct', () {
        expect(claims.portrait.path, equals(['portrait']));
      });
    });
  });
}
