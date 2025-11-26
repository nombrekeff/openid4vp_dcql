class Format {
  static const sd_jwt = Format('dc+sd-jwt');
  static const mso_mdoc = Format('dc+mso-mdoc');

  final String name;
  const Format(this.name);

  @override
  String toString() {
    return name;
  }
}
