class Format {
  static const sd_jwt = Format('dc+sd-jwt');
  static const mso_mdoc = Format('dc+mso-mdoc');
  static const w3c = Format('jwt_vc_json');

  // Convenience aliases

  /// Alias for [Format.mso_mdoc]
  static const mdoc = mso_mdoc;

  /// Alias for [Format.sd_jwt]
  static const jwt = sd_jwt;

  final String name;
  const Format(this.name);

  @override
  String toString() {
    return name;
  }
}
