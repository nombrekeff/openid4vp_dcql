import 'package:openid4vp_dcql/json.dart';

class ClaimSet with JsonSerializable {
  List<String> ids;

  ClaimSet({required this.ids});

  @override
  List<String> toJson() {
    return ids;
  }
}
