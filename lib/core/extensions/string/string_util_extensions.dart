/// Utility extensions for [String] class.
extension StringUtilExtensions on String {
  /// To use correct ellipsis behavior on text overflows.
  String get useCorrectEllipsis => replaceAll('', '\u200B');
}
