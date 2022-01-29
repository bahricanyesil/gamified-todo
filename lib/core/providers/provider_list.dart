import 'package:flutter/material.dart';
import 'package:gamified_todo/features/task/view-model/create_task_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../features/home/view-model/home_view_model.dart';
import '../../features/settings/view-model/settings_view_model.dart';
import '../managers/navigation/navigation_manager.dart';
import 'theme/theme_provider.dart';

/// Provides the list of providers will be used across the app.
class ProviderList {
  /// Singleton instance of [ProviderList].
  factory ProviderList() => _instance;
  ProviderList._();
  static final ProviderList _instance = ProviderList._();

  /// List of providers will be used for main [MultiProvider] class.
  static final List<SingleChildWidget> providers = <SingleChildWidget>[
    ChangeNotifierProvider<ThemeProvider>(
      create: (BuildContext context) => ThemeProvider(),
    ),
    ChangeNotifierProvider<HomeViewModel>(
      create: (BuildContext context) => HomeViewModel(),
    ),
    ChangeNotifierProvider<SettingsViewModel>(
      create: (BuildContext context) => SettingsViewModel(),
    ),
    ChangeNotifierProvider<CreateTaskViewModel>(
      create: (BuildContext context) => CreateTaskViewModel(),
    ),
    ChangeNotifierProvider<NavigationManager>(
      create: (BuildContext context) => NavigationManager(),
    ),
  ];
}
