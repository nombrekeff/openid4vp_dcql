import 'package:openid4vp_dcql/json.dart';

class Meta with JsonSerializable {
  final Map<String, dynamic> _meta;

  Meta({Map<String, dynamic>? meta}) : _meta = meta ?? {};

  dynamic get(String key) {
    return _meta[key];
  }

  Meta set(String key, dynamic value) {
    _meta[key] = value;
    return this;
  }

  Meta remove(String key) {
    _meta.remove(key);
    return this;
  }

  Meta clear() {
    _meta.clear();
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    return _meta;
  }

  static Meta? fromJson(Map<String, dynamic> c) {
    return Meta(meta: c);
  }
}
