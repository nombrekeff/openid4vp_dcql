import 'package:openid4vp_dcql/builder/credential_builder.dart';
import 'package:openid4vp_dcql/builder/credential_set_builder.dart';
import 'package:openid4vp_dcql/model/credential.dart';
import 'package:openid4vp_dcql/model/credential_set.dart';
import 'package:openid4vp_dcql/model/dcql_query.dart';
import 'package:openid4vp_dcql/enum/credential_type.dart';
import 'package:openid4vp_dcql/enum/format.dart';
import 'package:openid4vp_dcql/extensions/meta_set_filter_extension.dart';
import 'package:openid4vp_dcql/impl/default_validation.dart';
import 'package:openid4vp_dcql/validation/dcql_validator.dart';

/// Builds a DCQL query. Use the [DcqlBuilder] class to build a DCQL query.
/// Check the [example](https://github.com/manoloedge/openid4vp_dcql/tree/main/example) directory for more examples.
class DcqlBuilder {
  late final DcqlValidator validator;
  late final DcqlQuery _query;
  late final DcqlBuilder _dcqlBuilder;

  /// The DCQL query being built.
  DcqlQuery get query => _query;

  DcqlBuilder({DcqlValidator? validator, DcqlQuery? query}) {
    this.validator = validator ?? DcqlValidator();
    _query = query ?? DcqlQuery();
    _dcqlBuilder = this;
  }

  /// Adds a new credential to the query.
  ///
  /// [id] is the unique identifier for the credential.
  /// [format] is the format of the credential (e.g., mdoc, sd_jwt).
  /// [type] is a helper to set the format and meta filter based on a known credential type.
  DcqlCredentialBuilder credential(
    String id, {
    Format? format,
    CredentialType? type,
  }) {
    final credential = Credential(id: id);

    if (type != null) {
      credential.format = type.format;
      credential.meta.setFilter(type);
    } else if (format != null) {
      credential.format = format;
    }

    _query.credentials.add(credential);

    return DcqlCredentialBuilder(_dcqlBuilder, credential);
  }

  /// Adds a new credential set to the query.
  ///
  /// [required] specifies if the credential set is required.
  /// [options] is a list of options, where each option is a list of credential IDs.
  DcqlCredentialSetBuilder credentialSet({
    bool? required,
    List<List<String>>? options,
  }) {
    final credentialSet = CredentialSet(
      required: required,
      options: options ?? [],
    );
    _query.credentialSets ??= [];
    _query.credentialSets!.add(credentialSet);

    return DcqlCredentialSetBuilder(_dcqlBuilder, credentialSet);
  }

  /// Validates the current state of the query.
  /// Returns a [ValidationResult] with a list of errors if invalid.
  ValidationResult validate() {
    return validator.validate(query);
  }

  /// Builds the DCQL query.
  /// If [skipValidation] is false, the query will be validated before building.
  /// Throws a [ValidationException] if the query is invalid.
  DcqlQuery build({bool skipValidation = false}) {
    if (!skipValidation) {
      final result = validate();

      if (result.isInvalid) {
        throw ValidationException(result);
      }
    }

    return _query;
  }

  /// Separator, returns the current builder instance.
  ///
  /// Use this to visually separate logical blocks in the builder chain.
  DcqlBuilder get $_ => this;
}
