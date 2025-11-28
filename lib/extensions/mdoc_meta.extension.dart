import 'package:openid4vp_dcql/meta.dart';

extension MdocMetaExtension on Meta {
  Meta setFilter(String docType) {
    return set('doc_type', docType);
  }
}
