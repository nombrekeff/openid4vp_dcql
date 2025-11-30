import 'package:openid4vp_dcql/json.dart';

class Format with JsonSerializable {
  final String name;
  const Format(this.name);

  @override
  String toString() {
    return name;
  }

  @override
  toJson() {
    return name;
  }
}
