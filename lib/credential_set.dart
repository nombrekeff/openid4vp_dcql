import 'package:openid4vp_dcql/json.dart';

/// Defines a set of credentials that satisfy a query requirement.
///
/// This allows for complex logic like "Credential A AND (Credential B OR Credential C)".
class CredentialSet with JsonSerializable {
  /// A list of options, where each option is a list of credential IDs.
  ///
  /// To satisfy the credential set, at least one of the options must be satisfied.
  /// An option is satisfied if all credentials in the list are returned.
  List<List<String>> options;

  /// Whether this credential set is required.
  ///
  /// If `true` (default), the verifier requires this set to be satisfied.
  bool? required;

  CredentialSet({this.options = const [], this.required});

  @override
  Map<String, dynamic> toJson() {
    return {'options': options, if (required != null) 'required': required};
  }

  static CredentialSet fromJson(Map<String, dynamic> cs) {
    return CredentialSet(
      options: (cs['options'] as List<dynamic>)
          .map((option) => (option as List<dynamic>).map((e) => e as String).toList())
          .toList(),
      required: cs['required'] as bool?,
    );
  }
}
