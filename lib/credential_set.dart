import 'package:openid4vp_dcql/json.dart';

class CredentialSet with JsonSerializable {
  List<List<String>> options;
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
