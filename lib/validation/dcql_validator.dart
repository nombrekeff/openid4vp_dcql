import 'dart:convert';

import 'package:openid4vp_dcql/openid4vp_dcql.dart';

class ValidationResult {
  final bool _isValid;
  final String? _contextPath;
  final List<String>? _errors;

  ValidationResult({String? contextPath, bool isValid = true, List<String> errors = const []})
    : _isValid = isValid,
      _errors = errors,
      _contextPath = contextPath;

  ValidationResult.valid({String? contextPath, List<String> errors = const []})
    : _isValid = true,
      _errors = errors,
      _contextPath = contextPath;

  ValidationResult.invalid({String? contextPath, List<String> errors = const []})
    : _isValid = false,
      _errors = errors,
      _contextPath = contextPath;

  bool get isValid => _isValid;
  bool get isInvalid => !_isValid;

  List<String>? get errors => _errors;
  String? get contextPath => _contextPath;

  @override
  String toString() {
    return 'ValidationResult(isValid: $_isValid, errors: $_errors, contextPath: $_contextPath)';
  }
}

class FieldValidator {
  final ValidationResult Function(DcqlQuery) validate;

  FieldValidator(this.validate);
}

class ClaimValidator {
  ValidationResult validate({
    required Credential credential,
    required DcqlQuery query,
    required int credentialIndex,
  }) {
    if (credential.claims == null) {
      return ValidationResult.valid();
    }

    final claimIds = <String>{};

    if (credential.claims != null) {
      for (var j = 0; j < credential.claims!.length; j++) {
        final claim = credential.claims![j];
        final contextPath = 'query.credentials[$credentialIndex].claims[$j]';

        final idValidationResult = validateId(credential, claim, contextPath);
        if (!idValidationResult.isValid) return idValidationResult;

        if (claim.id != null) {
          if (claimIds.contains(claim.id)) {
            return ValidationResult.invalid(
              contextPath: '$contextPath.id',
              errors: ['Duplicate claim ID "${claim.id}" found in credential.'],
            );
          }
          claimIds.add(claim.id!);
        }

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
  final _claimSetValidator = ClaimSetValidator();

  ValidationResult validate(DcqlQuery query) {
    // ignore: unnecessary_null_comparison
    if (query.credentials == null || query.credentials.isEmpty) {
      return ValidationResult.invalid(
        contextPath: 'query.credentials',
        errors: ['Credentials list cannot be null or empty.'],
      );
    }

    final credentialIds = <String>{};

    for (var i = 0; i < query.credentials.length; i++) {
      final credential = query.credentials[i];
      final contextPath = 'query.credentials[$i]';

      // ignore: unnecessary_null_comparison
      if (credential.id == null || credential.id.isEmpty) {
        return ValidationResult.invalid(
          contextPath: '$contextPath.id',
          errors: ['Credential ID cannot be null or empty.'],
        );
      }

      if (credentialIds.contains(credential.id)) {
        return ValidationResult.invalid(
          contextPath: '$contextPath.id',
          errors: ['Duplicate credential ID "${credential.id}" found.'],
        );
      }
      credentialIds.add(credential.id);

      final claimValidationResult = _claimValidator.validate(
        credential: credential,
        query: query,
        credentialIndex: i,
      );

      if (!claimValidationResult.isValid) return claimValidationResult;

      final claimSetValidationResult = _claimSetValidator.validate(
        credential: credential,
        credentialIndex: i,
        query: query,
      );
      if (!claimSetValidationResult.isValid) return claimSetValidationResult;
    }

    return ValidationResult.valid();
  }
}

class CredentialSetValidator {
  ValidationResult validate(DcqlQuery query) {
    if (query.credentialSets == null) {
      return ValidationResult.valid();
    }

    final credentialIds = query.credentials.map((c) => c.id).toSet();

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
          final credentialId = option[k];
          if (!credentialIds.contains(credentialId)) {
            return ValidationResult.invalid(
              contextPath: 'query.credential_sets[$i].options[$j][$k]',
              errors: [
                'Credential ID "$credentialId" in credential set does not match any credential in the query.',
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
