import 'dart:convert';

import 'package:openid4vp_dcql/openid4vp_dcql.dart';

class ClaimValidator {
  ValidationResult validate({
    required Credential credential,
    required DcqlQuery query,
    required int credentialIndex,
  }) {
    if (credential.claims == null) {
      return ValidationResult.valid();
    }

    if (credential.claims != null) {
      for (var j = 0; j < credential.claims!.length; j++) {
        final claim = credential.claims![j];
        final contextPath = 'query.credentials[$credentialIndex].claims[$j]';

        final idValidationResult = validateId(credential, claim, contextPath);
        if (!idValidationResult.isValid) return idValidationResult;

        final pathValidationResult = validatePath(claim.path, '$contextPath.path');
        if (!pathValidationResult.isValid) return pathValidationResult;

        final valuesValidationResult = validateValues(claim.values, '$contextPath.values');
        if (!valuesValidationResult.isValid) return valuesValidationResult;
      }
    }

    return ValidationResult.valid();
  }

  ValidationResult validateId(Credential credential, Claim claim, String contextPath) {
    // REQUIRED if claim_sets is present in the Credential Query;
    // OPTIONAL otherwise. A string identifying the particular claim.
    // The value MUST be a non-empty string consisting of alphanumeric, underscore (_), or hyphen (-) characters. Within the particular claims array, the same id MUST NOT be present more than once.
    bool hasClaimSet = credential.claimSets != null && credential.claimSets!.isNotEmpty;

    if (claim.id == null && hasClaimSet) {
      return ValidationResult.invalid(
        contextPath: '$contextPath.id',
        errors: ['Claim ID is required if "claim_sets" is present in the Credential.'],
      );
    }

    if (claim.id != null && claim.id!.isNotEmpty) {
      // If id is provided, it must be non-empty
      final idPattern = RegExp(r'^[a-zA-Z0-9_-]+$');
      if (!idPattern.hasMatch(claim.id!)) {
        return ValidationResult.invalid(
          contextPath: '$contextPath.id',
          errors: [
            'Claim ID must consist of alphanumeric, underscore (_), or hyphen (-) characters.',
          ],
        );
      }
    }

    return ValidationResult.valid();
  }

  ValidationResult validatePath(List<dynamic> path, String contextPath) {
    if (path.isEmpty) {
      return ValidationResult.invalid(
        contextPath: contextPath,
        errors: ['Claim path cannot be empty.'],
      );
    }

    for (var k = 0; k < path.length; k++) {
      final pathElement = path[k];
      if (pathElement is! String && pathElement is! int && pathElement != null) {
        return ValidationResult.invalid(
          contextPath: '$contextPath[$k]',
          errors: ['Claim path elements must be String, int, or null.'],
        );
      }
    }

    return ValidationResult.valid();
  }

  ValidationResult validateValues(List<Object>? values, String contextPath) {
    if (values == null) {
      return ValidationResult.valid();
    }

    if (values.isEmpty) {
      return ValidationResult.invalid(
        contextPath: contextPath,
        errors: ['Claim "values" cannot be an empty list if provided.'],
      );
    }

    for (var k = 0; k < values.length; k++) {
      final value = values[k];
      if (value is! String && value is! int && value is! bool) {
        return ValidationResult.invalid(
          contextPath: '$contextPath[$k]',
          errors: ['Claim "values" must be String, int, or bool.'],
        );
      }
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
        final contextPath = 'query.credentials[$credentialIndex].claim_sets[$j]';

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
  // final _claimSetValidator = ClaimSetValidator();

  ValidationResult validate(DcqlQuery query) {
    if (query.credentials.isEmpty) {
      return ValidationResult.invalid(
        contextPath: 'query.credentials',
        errors: ['DCQL query must contain at least one credential'],
      );
    }

    for (var i = 0; i < query.credentials.length; i++) {
      var credential = query.credentials[i];

      // The id MUST be a non-empty string consisting of alphanumeric, underscore (_), or hyphen (-) characters
      final idPattern = RegExp(r'^[a-zA-Z0-9_-]+$');
      if (!idPattern.hasMatch(credential.id) || credential.id.isEmpty) {
        return ValidationResult.invalid(
          contextPath: 'query.credentials[$i].id',
          errors: [
            'Credential ID cannot be empty & must consist of alphanumeric, underscore (_), or hyphen (-) characters.',
          ],
        );
      }

      // Additional credential validations can be added here
      // Validate meta, for sd jwt should have vct_values, and mdoc should have doctype_value

      // claims
      if (credential.claims != null && credential.claims!.isEmpty) {
        return ValidationResult.invalid(
          contextPath: 'query.credentials[$i].claims',
          errors: ['Credential claims cannot be an empty list if provided.'],
        );
      } else if (credential.claims != null) {
        final claimValidationResult = _claimValidator.validate(
          credential: credential,
          query: query,
          credentialIndex: i,
        );

        if (claimValidationResult.isInvalid) {
          return claimValidationResult;
        }
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

class DcqlValidator {
  final _queryValidator = QueryValidator();

  ValidationResult validate(DcqlQuery query) {
    return _queryValidator.validate(query);
  }

  ValidationResult validateJson(String query) {
    final dcqlQuery = DcqlQuery.fromJson(json.decode(query));

    return validate(dcqlQuery);
  }
}
