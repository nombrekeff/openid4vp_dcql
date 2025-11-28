class Meta {
  Map<String, dynamic> _meta;

  Meta({Map<String, dynamic>? meta}) : _meta = meta ?? {};

  Meta get(String key) {
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

  Map<String, dynamic> toMap() => _meta;
}
