import 'package:openid4vp_dcql/json.dart';

/// Represents a claim requested from a credential.
class Claim with JsonSerializable {
  /// An optional identifier for this claim.
  ///
  /// This ID is used to reference the claim in [Credential.claimSets].
  final String? id;

  /// The path to the claim in the credential. Must not be empty. String / int / null values are allowed.
  final List<dynamic> path;

  /// A list of specific values requested for this claim.
  ///
  /// If provided, the wallet should only return the claim if its value matches one of these values.
  final List<Object>? values;

  Claim({this.id, required this.path, this.values});

  /// Creates a copy of this claim with the given fields replaced with the new values.
  Claim copyWith({String? id, List<Object>? values}) {
    return Claim(path: path, id: id ?? this.id, values: values ?? this.values);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'path': path,
      if (values != null) 'values': values,
    };
  }

  static Claim fromJson(Map<String, dynamic> claim) {
    return Claim(
      id: claim['id'] as String?,
      path: (claim['path'] as List<dynamic>),
      values: (claim['values'] as List<dynamic>?)?.cast<Object>(),
    );
  }
}
