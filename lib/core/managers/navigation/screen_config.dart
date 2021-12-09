import 'package:flutter/material.dart';

import '../../../features/screens_shelf.dart';

/// [ScreenConfig] class to determine the properties of pages to navigate.
class ScreenConfig {
  /// Constructor for [ScreenConfig] class.
  const ScreenConfig({
    required this.path,
    required this.builder,
  });

  /// Screen config for default screen, in this case it is [HomeScreen].
  ScreenConfig.defaultScreen()
      : path = '/',
        builder = (() => const SplashScreen());

  /// Screen config for default screen, in this case it is [HomeScreen].
  ScreenConfig.home()
      : path = '/home',
        builder = (() => const HomeScreen());

  /// Path of the page, will be the url on web.
  final String path;

  /// Builder method to navivgate to the page.
  final Widget Function() builder;
}
