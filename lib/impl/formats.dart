import 'package:openid4vp_dcql/constants.dart';
import 'package:openid4vp_dcql/enum/format.dart';

abstract class Formats {
  // NOTE: remember to update the 'values' list when adding new formats
  static const values = [sd_jwt, mso_mdoc, w3c];

  // DCQL format values
  static const sd_jwt = Format(DcqlConstants.dc_sd_jwt);
  static const mso_mdoc = Format(DcqlConstants.mso_mdoc);
  static const w3c = Format(DcqlConstants.w3c_vc_json);

  /// Alias for [Format.mso_mdoc]
  static const mdoc = mso_mdoc;

  /// Alias for [Format.sd_jwt]
  static const jwt = sd_jwt;
}
