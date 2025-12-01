import 'package:openid4vp_dcql/json.dart';

/// Defines a trusted authority (issuer) for a credential.
class TrustedAuthority with JsonSerializable {
  /// The type of the trusted authority (e.g., "issuer").
  final String type;

  /// A list of trusted values (e.g., issuer IDs or public keys).
  final List<String> values;

  TrustedAuthority({required this.type, required this.values}) {
    assert(values.isNotEmpty, 'TrustedAuthority values cannot be an empty list');
  }

  @override
  Map<String, dynamic> toJson() => {'type': type, 'values': values};

  static TrustedAuthority fromJson(Map<String, dynamic> json) {
    return TrustedAuthority(
      type: json['type'] as String,
      values: (json['values'] as List<dynamic>).cast<String>(),
    );
  }
}
