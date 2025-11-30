import 'package:openid4vp_dcql/enum/doc_type.dart';
import 'package:openid4vp_dcql/meta.dart';

extension MdocMetaExtension on Meta {
  Meta setFilter(DocType docType) {
    return set('doc_type', docType.id);
  }
}
