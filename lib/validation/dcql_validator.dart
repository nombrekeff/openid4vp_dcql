import 'package:openid4vp_dcql/openid4vp_dcql.dart';

/// The result of a DCQL query validation.
class ValidationResult {
  final bool _isValid;
  final String? _contextPath;
  final List<String>? _errors;

  ValidationResult({
    String? contextPath,
    bool isValid = true,
    List<String> errors = const [],
  })  : _isValid = isValid,
        _errors = errors,
        _contextPath = contextPath;

  /// Creates a valid result.
  ValidationResult.valid({String? contextPath, List<String> errors = const []})
      : _isValid = true,
        _errors = errors,
        _contextPath = contextPath;

  /// Creates an invalid result with a list of errors.
  ValidationResult.invalid({
    String? contextPath,
    List<String> errors = const [],
  })  : _isValid = false,
        _errors = errors,
        _contextPath = contextPath;

  /// Returns `true` if the validation passed.
  bool get isValid => _isValid;

  /// Returns `true` if the validation failed.
  bool get isInvalid => !_isValid;

  /// A list of error messages if the validation failed.
  List<String>? get errors => _errors;

  /// The path to the invalid field (e.g., `query.credentials[0].id`).
  String? get contextPath => _contextPath;

  @override
  String toString() {
    return 'ValidationResult(isValid: $_isValid, errors: ${_errors?.join(', ')}, contextPath: $_contextPath)';
  }
}

/// An exception thrown when a DCQL query is invalid.
class ValidationException implements Exception {
  final ValidationResult result;

  ValidationException(this.result);

  @override
  String toString() {
    return 'ValidationException(result: $result)';
  }
}

/// A helper class for defining field validators.
class FieldValidator {
  final ValidationResult Function(DcqlQuery) validate;

  FieldValidator(this.validate);
}
