export 'builder/dcql_builder.dart';
export 'claim.dart';
export 'claims.dart';
export 'credential.dart';
export 'credential_set.dart';
export 'dcql_query.dart';
export 'enum/claim_type.dart';
export 'enum/doc_type.dart';
export 'enum/format.dart';
export 'extensions/mdoc_meta.extension.dart';
export 'json.dart';
export 'meta.dart';
export 'trusted_authorities.dart';

// TODO: Add way of askign for all claims
// TODO: Add documentation and links to specs
// TODO: Make clear it's for the 1.0 spec and create version accordingly
//          all versions should follow spec version (spec 1 => lib 1.0.0, spec 2 => 2.0.0)
// TODO: Add examples and tests for all features
// TODO: Add validation - make optional? maybe enable for debug mode?
// TODO: Consider making Claim generic to allow for different claim types (e.g., string, int, bool, etc.)
// TODO: Organize magic strings and constants into a single file or class
// TODO: Add quality of life improvements like copyWith, toString, equals, hashCode, etc.
// TODO: 