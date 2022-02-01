import 'package:collection/collection.dart';
import '../enum/enum_extensions.dart';

/// Type conversion extensions on [String] class.
extension TypeConversions on String? {
  /// Converts the string to an enum according to the given list of values.
  T? toEnum<T extends Enum>(List<T> values) => values
      .firstWhereOrNull((T e) => e.value.toLowerCase() == this?.toLowerCase());

  /// Capitalizes the string.
  String get capitalize =>
      '${this?[0].toUpperCase()}${this?.toLowerCase().substring(1)}';
}
