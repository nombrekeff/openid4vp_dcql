import 'package:openid4vp_dcql/enum/credential_type.dart';
import 'package:openid4vp_dcql/enum/doc_type.dart';
import 'package:openid4vp_dcql/impl/formats.dart';
import 'package:openid4vp_dcql/meta.dart';

extension MetaSetFilterExtension on Meta {
  Meta setFilter(CredentialType type) {
    switch (type.format) {
      case Formats.mdoc:
        return setDocType(type.docType);
      case Formats.jwt:
        return setVctValues([type.docType.id]);
    }

    return this;
  }

  Meta setDocType(DocType docType) {
    return set('doctype_value', docType.id);
  }


  Meta setVctValues(List<String> vctValues) {
    return set('vct_values', vctValues);
  }
}
