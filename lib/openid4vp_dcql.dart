export 'builder/dcql_builder.dart';
export 'claim.dart';
export 'credential.dart';
export 'credential_set.dart';
export 'dcql_query.dart';
export 'enum/credential_type.dart';
export 'enum/doc_type.dart';
export 'enum/format.dart';
export 'extensions/mdoc_meta.extension.dart';
export 'impl/claims.dart';
export 'impl/credential_types.dart';
export 'impl/doc_types.dart';
export 'impl/formats.dart';
export 'json.dart';
export 'meta.dart';
export 'trusted_authorities.dart';
export 'validation/dcql_validator.dart';

// TODO: Consider making Claim generic to allow for different claim types (e.g., string, int, bool, etc.)
// TODO: Organize magic strings and constants into a single file or class
// TODO: Add quality of life improvements like copyWith, toString, equals, hashCode, etc.
// TODO:
