import 'package:openid4vp_dcql/enum/format.dart';
import 'package:openid4vp_dcql/meta.dart';

class CredentialQuery {
  final String id;
  final Meta meta;
  final Format format;

  const CredentialQuery({
    required this.id,
    required this.meta,
    required this.format,
  });
}
