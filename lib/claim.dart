import 'package:openid4vp_dcql/json.dart';

class Claim with JsonSerializable {
  final String? id;

  /// The path to the claim in the credential. Must not be empty. String / int / null values are allowed.
  final List<dynamic> path;
  final List<Object>? values;

  Claim({this.id, required this.path, this.values});

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
