import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../managers/navigation/navigation_manager.dart';

/// Provides the list of providers will be used across the app.
class ProviderList {
  /// Singleton instance of [ProviderList].
  factory ProviderList() => _instance;
  ProviderList._();
  static final ProviderList _instance = ProviderList._();

  /// List of providers will be used for main [MultiProvider] class.
  static final List<SingleChildWidget> providers = <SingleChildWidget>[
    ChangeNotifierProvider<NavigationManager>(
      create: (BuildContext context) => NavigationManager(),
    ),
  ];
}
