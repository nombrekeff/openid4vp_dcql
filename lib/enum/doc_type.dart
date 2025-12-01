// Represents a document type identifier used in verifiable credential requests.
//
// Use predefined constants for common document types, or create custom instances:
// ```dart
// DocType.mDocDriverLicense;
// DocType('org.iso.18013.5.1.mDL');
// ```
// Predefined document types include official standards and common pilot variations.
//
// See relevant standards for more details.
// - ISO/IEC 18013-5:2021 (mDoc)
// - EUDI Wallet Architecture and Reference Framework
// - IETF Draft for Selective Disclosure JWT VC
import 'package:openid4vp_dcql/json.dart';

class DocType with JsonSerializable {
  final String id;
  const DocType(this.id);

  @override
  String toString() => id;

  @override
  Map<String, dynamic> toJson() => {'doctype_value': id};
}
