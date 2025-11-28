import 'package:openid4vp_dcql/json.dart';

class ClaimSet with JsonSerializable {
  List<String> ids;

  ClaimSet({required this.ids});

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
