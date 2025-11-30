import 'package:openid4vp_dcql/json.dart';

class TrustedAuthority with JsonSerializable {
  final String type;
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
