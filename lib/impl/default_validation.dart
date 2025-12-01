import 'dart:convert';

import 'package:openid4vp_dcql/impl/eskema_validators.dart';
import 'package:openid4vp_dcql/openid4vp_dcql.dart';

class ClaimValidator {
  ValidationResult validate({
    required Credential credential,
    required DcqlQuery query,
    required int credentialIndex,
  }) {
    if (credential.claims != null) {
      // list of seen claim ids - used to check for duplicates
      final seenIds = <String>{};

      for (var j = 0; j < credential.claims!.length; j++) {
        final claim = credential.claims![j];
        final contextPath = 'query.credentials[$credentialIndex].claims[$j]';

        // Check for duplicate claim ids
        if (claim.id != null) {
          if (seenIds.contains(claim.id)) {
            return ValidationResult.invalid(
              contextPath: '$contextPath.id',
              errors: ['Duplicate claim ID "${claim.id}" found'],
            );
          }

          seenIds.add(claim.id!);
        }

        final idResult = validateId(credential, claim, contextPath);
        if (!idResult.isValid) return idResult;

        final pathResult = validatePath(claim.path, '$contextPath.path');
        if (!pathResult.isValid) return pathResult;

        final valResult = validateValues(claim.values, '$contextPath.values');
        if (!valResult.isValid) return valResult;
      }
    }

    return ValidationResult.valid();
  }

  ValidationResult validateId(
    Credential credential,
    Claim claim,
    String contextPath,
  ) {
    // REQUIRED if claim_sets is present in the Credential Query;
    // OPTIONAL otherwise. A string identifying the particular claim.
    // The value MUST be a non-empty string consisting of alphanumeric, underscore (_), or hyphen (-) characters. Within the particular claims array, the same id MUST NOT be present more than once.
    bool hasClaimSet =
        credential.claimSets != null && credential.claimSets!.isNotEmpty;

    if (claim.id == null) {
      if (hasClaimSet) {
        return ValidationResult.invalid(
          contextPath: '$contextPath.id',
          errors: [
            'Claim ID is required if "claim_sets" is present in the Credential.',
          ],
        );
      }

      return ValidationResult.valid();
    }

    final isValidId = idValidator.validate(claim.id);

    if (!isValidId.isValid) {
      return ValidationResult.invalid(
        contextPath: '$contextPath.id',
        errors: [isValidId.expectations.map((e) => e.toString()).join(', ')],
      );
    }

    return ValidationResult.valid();
  }

  ValidationResult validatePath(List<dynamic> path, String contextPath) {
    final pathResult = pathValidator.validate(path);

    if (pathResult.isNotValid) {
      return ValidationResult.invalid(
        contextPath: contextPath,
        errors: [pathResult.expectations.map((e) => e.toString()).join(', ')],
      );
    }

    return ValidationResult.valid();
  }

  ValidationResult validateValues(List<Object>? values, String contextPath) {
    final valuesResult = valuesValidator.validate(values);

    if (!valuesResult.isValid) {
      return ValidationResult.invalid(
        contextPath: contextPath,
        errors: [valuesResult.expectations.map((e) => e.toString()).join(', ')],
      );
    }

    return ValidationResult.valid();
  }
}

class ClaimSetValidator {
  ValidationResult validate({
    required Credential credential,
    required DcqlQuery query,
    required int credentialIndex,
  }) {
    if (credential.claimSets == null) {
      return ValidationResult.valid();
    }

    // OPTIONAL. A non-empty array containing arrays of identifiers for elements in claims that specifies which combinations of claims for the Credential are requested. The rules for selecting claims to send are defined in Section 6.4.1.
    if (credential.claimSets != null) {
      for (var j = 0; j < credential.claimSets!.length; j++) {
        final claimSet = credential.claimSets![j];
        final contextPath =
            'query.credentials[$credentialIndex].claim_sets[$j]';

        if (claimSet.isEmpty) {
          return ValidationResult.invalid(
            contextPath: contextPath,
            errors: ['Claim set cannot be an empty list.'],
          );
        }

        for (var k = 0; k < claimSet.length; k++) {
          final claimId = claimSet[k];
          final contextPathElement = '$contextPath[$k]';

          final matchingClaim = credential.claims?.cast<Claim?>().firstWhere(
                (claim) => claim?.id == claimId,
                orElse: () => null,
              );

          if (matchingClaim == null) {
            return ValidationResult.invalid(
              contextPath: contextPathElement,
              errors: [
                'Claim ID "$claimId" in claim set does not match any claim in the credential.',
              ],
            );
          }
        }
      }
    }

    return ValidationResult.valid();
  }
}

class CredentialsValidator {
  final _claimValidator = ClaimValidator();
  final _claimSetValidator = ClaimSetValidator();

  ValidationResult validate(DcqlQuery query) {
    if (query.credentials.isEmpty) {
      return ValidationResult.invalid(
        contextPath: 'query.credentials',
        errors: ['DCQL query must contain at least one credential'],
      );
    }

    final seenIds = <String>{};
    for (var i = 0; i < query.credentials.length; i++) {
      var credential = query.credentials[i];

      if (seenIds.contains(credential.id)) {
        return ValidationResult.invalid(
          contextPath: 'query.credentials[$i].id',
          errors: ['Duplicate credential ID "${credential.id}" found'],
        );
      }
      seenIds.add(credential.id);

      // The id MUST be a non-empty string consisting of alphanumeric, underscore (_), or hyphen (-) characters
      final isValidId = idValidator.isValid(credential.id);
      if (!isValidId) {
        return ValidationResult.invalid(
          contextPath: 'query.credentials[$i].id',
          errors: [
            'Credential ID cannot be empty & must consist of alphanumeric, underscore (_), or hyphen (-) characters.',
          ],
        );
      }

      // claims
      if (credential.claims != null && credential.claims!.isEmpty) {
        return ValidationResult.invalid(
          contextPath: 'query.credentials[$i].claims',
          errors: ['Credential claims cannot be an empty list if provided.'],
        );
      }

      if (credential.claims != null) {
        final claimValidationResult = _claimValidator.validate(
          credential: credential,
          query: query,
          credentialIndex: i,
        );

        if (claimValidationResult.isInvalid) {
          return claimValidationResult;
        }
      }

      final claimSetValidationResult = _claimSetValidator.validate(
        credential: credential,
        query: query,
        credentialIndex: i,
      );

      if (claimSetValidationResult.isInvalid) {
        return claimSetValidationResult;
      }
    }

    return ValidationResult.valid();
  }
}

class CredentialSetValidator {
  ValidationResult validate(DcqlQuery query) {
    if (query.credentialSets == null) {
      return ValidationResult.valid();
    }

    final validCredentialIds = query.credentials.map((c) => c.id).toSet();

    for (var i = 0; i < query.credentialSets!.length; i++) {
      final credentialSet = query.credentialSets![i];

      if (credentialSet.options.isEmpty) {
        return ValidationResult.invalid(
          contextPath: 'query.credential_sets[$i].options',
          errors: ['CredentialSet options cannot be an empty list.'],
        );
      }

      for (var j = 0; j < credentialSet.options.length; j++) {
        final option = credentialSet.options[j];
        if (option.isEmpty) {
          return ValidationResult.invalid(
            contextPath: 'query.credential_sets[$i].options[$j]',
            errors: ['CredentialSet option cannot be an empty list.'],
          );
        }

        for (var k = 0; k < option.length; k++) {
          final credId = option[k];

          if (!validCredentialIds.contains(credId)) {
            return ValidationResult.invalid(
              contextPath: 'query.credential_sets[$i].options[$j][$k]',
              errors: [
                'Credential ID "$credId" in credential set does not match any credential in the query.',
              ],
            );
          }
        }
      }
    }

    return ValidationResult.valid();
  }
}

class QueryValidator {
  final _credentialsValidator = CredentialsValidator();
  final _credentialSetValidator = CredentialSetValidator();

  ValidationResult validate(DcqlQuery query) {
    final credRes = _credentialsValidator.validate(query);
    if (credRes.isInvalid) return credRes;

    final credSetRes = _credentialSetValidator.validate(query);
    if (credSetRes.isInvalid) return credSetRes;

    return ValidationResult.valid();
  }
}

/// Validates a DCQL query against the specification.
///
/// Checks for:
/// * Unique IDs for credentials and claims.
/// * Valid references in `claim_sets` and `credential_sets`.
/// * Correct value types and non-empty paths.
/// * Required fields.
class DcqlValidator {
  final _queryValidator = QueryValidator();

  /// Validates a [DcqlQuery] object.
  ValidationResult validate(DcqlQuery query) {
    return _queryValidator.validate(query);
  }

  /// Validates a JSON string representing a DCQL query.
  ValidationResult validateJson(String query) {
    final dcqlQuery = DcqlQuery.fromJson(json.decode(query));

    return validate(dcqlQuery);
  }
}
