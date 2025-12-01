import 'package:openid4vp_dcql/openid4vp_dcql.dart';

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

  ValidationResult.valid({String? contextPath, List<String> errors = const []})
      : _isValid = true,
        _errors = errors,
        _contextPath = contextPath;

  ValidationResult.invalid({
    String? contextPath,
    List<String> errors = const [],
  })  : _isValid = false,
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

class ValidationException implements Exception {
  final ValidationResult result;

  ValidationException(this.result);

  @override
  String toString() {
    return 'ValidationException(result: $result)';
  }
}

class FieldValidator {
  final ValidationResult Function(DcqlQuery) validate;

  FieldValidator(this.validate);
}
