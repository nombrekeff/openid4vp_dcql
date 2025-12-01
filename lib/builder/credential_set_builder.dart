import 'package:openid4vp_dcql/builder/dcql_builder.dart';
import 'package:openid4vp_dcql/model/credential_set.dart';

class DcqlCredentialSetBuilder extends DcqlBuilder {
  late final DcqlCredentialSetBuilder _credentialSetBuilder;
  final CredentialSet _credentialSet;

  DcqlCredentialSetBuilder(DcqlBuilder parent, this._credentialSet)
      : super(query: parent.query, validator: parent.validator) {
    _credentialSetBuilder = this;
  }

  /// Adds an option to the credential set.
  ///
  /// [option] is a list of credential IDs that satisfy the requirement.
  DcqlCredentialSetBuilder option(List<String> option) {
    _credentialSet.options.add(option);
    return _credentialSetBuilder;
  }

  /// Sets whether this credential set is required.
  DcqlCredentialSetBuilder required([bool required = true]) {
    _credentialSet.required = required;
    return _credentialSetBuilder;
  }

  @override
  DcqlCredentialSetBuilder get $_ => this;
}
