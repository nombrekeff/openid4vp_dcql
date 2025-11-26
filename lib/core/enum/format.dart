enum Format {
  sd_jwt,
  mso_mdoc;

  String get name {
    switch (this) {
      case Format.sd_jwt:
        return 'sd-jwt';
      case Format.mso_mdoc:
        return 'dc+sd-jwt';
    }
  }

  @override
  String toString() => name;
}
