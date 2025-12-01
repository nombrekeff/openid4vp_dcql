import 'package:openid4vp_dcql/json.dart';

/// Defines the metadata of a DCQL request.
///
/// Metadata can include information like the document type or other format-specific properties.
class Meta with JsonSerializable {
  final Map<String, dynamic> _meta;

  Meta({Map<String, dynamic>? meta}) : _meta = meta ?? {};

  /// Gets a metadata value by key.
  dynamic get(String key) {
    return _meta[key];
  }

  /// Sets a metadata value.
  Meta set(String key, dynamic value) {
    _meta[key] = value;
    return this;
  }

  /// Removes a metadata value.
  Meta remove(String key) {
    _meta.remove(key);
    return this;
  }

  /// Clears all metadata.
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
