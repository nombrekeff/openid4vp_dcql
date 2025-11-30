import 'package:openid4vp_dcql/json.dart';

class Claim with JsonSerializable {
  final String? id;

  /// The path to the claim in the credential. Must not be empty. String / int / null values are allowed.
  final List<dynamic> path;
  late final List<Object>? values;

  Claim({this.id, required this.path, this.values}) {
    assert(path.isNotEmpty, 'Claim path cannot be empty');
    assert(values == null || values!.isNotEmpty, 'Claim values cannot be an empty list');
    assert(
      path.every((e) => e is String || e is int || e == null),
      'Claim path elements must be String, int, or null',
    );

    _validateValues(values);
  }

  // TODO: Move this to a validator class?
  void _validateValues(List<Object>? v) {
    if (v == null) return;
    if (v.isEmpty) {
      throw ArgumentError('Claim values cannot be an empty list if provided.');
    }

    for (final element in v) {
      // The spec says: strings, integers, or booleans.
      final isValid = element is String || element is int || element is bool;

      if (!isValid) {
        throw ArgumentError(
          'Invalid claim value type: ${element.runtimeType}. '
          'DCQL only supports String, int, and bool.',
        );
      }
    }
  }

  Claim copyWith({String? id, List<Object>? values}) {
    return Claim(path: path, id: id ?? this.id, values: values ?? this.values);
  }

  @override
  Map<String, dynamic> toJson() {
    return {if (id != null) 'id': id, 'path': path, if (values != null) 'values': values};
  }
}
