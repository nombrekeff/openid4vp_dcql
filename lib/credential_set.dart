import 'package:openid4vp_dcql/json.dart';

class CredentialSet with JsonSerializable {
  List<List<String>> options;
  bool? required;

  CredentialSet({this.options = const [], this.required});

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
