import 'package:flutter/material.dart';

import 'screen_config.dart';

/// Route information parser
class CustomRouteInfoParser extends RouteInformationParser<ScreenConfig> {
  /// Default screen to route in any unexpected situation.
  final ScreenConfig defaultScreen = ScreenConfig.defaultScreen();

  @override
  Future<ScreenConfig> parseRouteInformation(
      RouteInformation routeInformation) async {
    final Uri uri = Uri.parse(routeInformation.location!);
    if (uri.pathSegments.isEmpty) return defaultScreen;
    switch (uri.pathSegments[0]) {
      case 'home':
        return ScreenConfig.defaultScreen();
    }

    return defaultScreen;
  }

  @override
  RouteInformation? restoreRouteInformation(ScreenConfig configuration) {
    if (configuration.path == defaultScreen.path) return null;
    return RouteInformation(location: configuration.path);
  }
}
