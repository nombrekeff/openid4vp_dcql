/// Mark classes as JSON-serializable by
/// using this mixin.
mixin JsonSerializable {
  /// Converts the object to a JSON-serializable value.
  dynamic toJson();
}