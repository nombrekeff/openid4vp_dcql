import 'package:openid4vp_dcql/json.dart';

class Claim with JsonSerializable {
  final String? id;
  final List<String> path;
  final List<dynamic>? values;

  Claim({this.id, required this.path, this.values}) {
    assert(path.isNotEmpty, 'Claim path cannot be empty');
    assert(values == null || values!.isNotEmpty, 'Claim values cannot be an empty list');
  }

  Claim copyWith({String? id, List<dynamic>? values}) {
    return Claim(path: path, id: id ?? this.id, values: values ?? this.values);
  }

  @override
  Map<String, dynamic> toJson() {
    return {if (id != null) 'id': id, 'path': path, if (values != null) 'values': values};
  }
}
