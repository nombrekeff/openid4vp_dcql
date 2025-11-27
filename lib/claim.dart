class Claim {
  final String id;
  final List<String> path;
  const Claim({required this.id, required this.path});

  factory Claim.mdoc({
    required String id,

    /// The namespace of the claim: e.g., "org.iso.18013.5.1" / Use MdocNamespace.<> constants where possible
    required String namespace,
    required List<String> path,
  }) = MdocClaim;
}

class MdocClaim extends Claim {
  static const String namespaceIso18013_5_1 = "org.iso.18013.5.1";
  static const String namespaceIso7367_1 = "org.iso.7367.1";

  static const String nsDriversLicense = namespaceIso18013_5_1;
  static const String nsIdCard = namespaceIso7367_1;

  /// Creates a new MdocClaim.
  ///
  /// `namespace` is the namespace of the claim:
  /// e.g., "org.iso.18013.5.1" for drivers license, "org.iso.7367.1" for ID card, etc...
  ///
  /// Check out specification for more.
  MdocClaim({
    required super.id,
    required String namespace,
    required List<String> path,
  }) : super(path: path..insert(0, namespace));

  MdocClaim.driversLicense({required super.id, required List<String> path})
    : super(path: path..insert(0, nsDriversLicense));

  MdocClaim.idCard({required super.id, required List<String> path})
    : super(path: path..insert(0, nsIdCard));
}
