import 'package:openid4vp_dcql/json.dart';

class Claim with JsonSerializable {
  final String? id;
  final List<String> path;
  const Claim({this.id, required this.path});

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
