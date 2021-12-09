import 'dart:math';

import 'package:flutter/material.dart';
import '../constants/enums/sizes.dart';

/// Provides dynamic size values (height/width) by using [MediaQueryData].
/// It provides responsive [height], [width] and [responsiveSize] data
/// that are changing when you change your window size.
/// Also contains [EdgeInsets] values for responsive paddings/margins.
class DynamicSize {
  /// Default constructor for [DynamicSize] class.
  DynamicSize(this.context) {
    _mediaQuery = MediaQuery.of(context);
  }

  late MediaQueryData _mediaQuery;

  /// Context that is given as argument in the constructor.
  final BuildContext context;

  /// One percent of the screen height, in terms of logical pixels.
  double get height => _mediaQuery.size.height * 0.01;

  /// One percent of the screen width, in terms of logical pixels.
  double get width => _mediaQuery.size.width * 0.01;

  /// Provides responsive base size value by using default 16/9 ratio.
  double get responsiveSize =>
      min(height * 16, width * 9) / (isLandscape ? 30 : 40);

  /// Customized low height value.
  double get lowHeight => height * 1.5;

  /// Customized low width value.
  double get lowWidth => width * 1.5;

  /// Customized low-medium height value.
  double get lowMedHeight => height * 2;

  /// Customized low-medium width value.
  double get lowMedWidth => width * 2;

  /// Customized medium height value.
  double get medHeight => height * 2.8;

  /// Customized medium width value.
  double get medWidth => width * 2.8;

  /// Customized medium-high height value.
  double get medHighHeight => height * 4.5;

  /// Customized medium-high width value.
  double get medHighWidth => width * 4.5;

  /// Customized high height value.
  double get highHeight => height * 6.5;

  /// Customized high width value.
  double get highWidth => width * 6.5;

  /// Returns padding from all edges acc. to the given [sizeType].
  EdgeInsets allPadding(Sizes sizeType) {
    final List<double> sizedValues = _getSizedValue(sizeType);
    return EdgeInsets.symmetric(
        horizontal: sizedValues[0], vertical: sizedValues[1]);
  }

  /// Returns padding from vertical edges acc. to the given [sizeType].
  EdgeInsets verticalPadding(Sizes sizeType) {
    final List<double> sizedValues = _getSizedValue(sizeType);
    return EdgeInsets.symmetric(vertical: sizedValues[1]);
  }

  /// Returns padding from horizontal edges acc. to the given [sizeType].
  EdgeInsets horizontalPadding(Sizes sizeType) {
    final List<double> sizedValues = _getSizedValue(sizeType);
    return EdgeInsets.symmetric(horizontal: sizedValues[0]);
  }

  /// Returns padding from the left edge acc. to the given [sizeType].
  EdgeInsets leftPadding(Sizes sizeType) {
    final List<double> sizedValues = _getSizedValue(sizeType);
    return EdgeInsets.only(left: sizedValues[0]);
  }

  /// Returns padding from the right edge acc. to the given [sizeType].
  EdgeInsets rightPadding(Sizes sizeType) {
    final List<double> sizedValues = _getSizedValue(sizeType);
    return EdgeInsets.only(right: sizedValues[0]);
  }

  /// Returns padding from the top edge acc. to the given [sizeType].
  EdgeInsets topPadding(Sizes sizeType) {
    final List<double> sizedValues = _getSizedValue(sizeType);
    return EdgeInsets.only(top: sizedValues[1]);
  }

  /// Returns padding from the bottom edge acc. to the given [sizeType].
  EdgeInsets bottomPadding(Sizes sizeType) {
    final List<double> sizedValues = _getSizedValue(sizeType);
    return EdgeInsets.only(bottom: sizedValues[1]);
  }

  List<double> _getSizedValue(Sizes sizeType) {
    late double horizontalValue;
    late double verticalValue;
    switch (sizeType) {
      case Sizes.low:
        horizontalValue = lowWidth;
        verticalValue = lowHeight;
        break;
      case Sizes.lowMed:
        horizontalValue = lowMedWidth;
        verticalValue = lowMedHeight;
        break;
      case Sizes.med:
        horizontalValue = medWidth;
        verticalValue = medHeight;
        break;
      case Sizes.medHigh:
        horizontalValue = medHighWidth;
        verticalValue = medHighHeight;
        break;
      case Sizes.high:
        horizontalValue = highWidth;
        verticalValue = highHeight;
        break;
    }
    return <double>[horizontalValue, verticalValue];
  }

  /// Maximum possible height for the screen.
  double get maxPossibleHeight => _mediaQuery.size.height;

  /// Maximum possible width for the screen.
  double get maxPossibleWidth => _mediaQuery.size.width;

  /// Checks whether the screen is in landscape mode.
  bool get isLandscape => height / width < 1.05;
}
