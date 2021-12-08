import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/managers/navigation_shelf.dart';
import 'core/providers/provider_list.dart';

/// Material app widget of the app.
class InitialApp extends StatelessWidget {
  /// Default constructor for [InitialApp] widget.
  const InitialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
      providers: ProviderList.providers,
      child: MaterialApp.router(
        title: 'Gamified To Do',
        debugShowCheckedModeBanner: false,
        routerDelegate: NavigationManager(),
        backButtonDispatcher: RootBackButtonDispatcher(),
        routeInformationParser: CustomRouteInfoParser(),
      ));
}
