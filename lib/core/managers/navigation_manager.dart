import 'dart:async';

import 'package:flutter/material.dart';

import 'screen_config.dart';

/// Custom navigation manager
class NavigationManager extends RouterDelegate<ScreenConfig>
    with
        // ignore: prefer_mixin
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<ScreenConfig> {
  /// Singleton instance of [NavigationManager].
  factory NavigationManager() => _instance;
  NavigationManager._() {
    unawaited(setInitialRoutePath(ScreenConfig.defaultScreen()));
  }
  static final NavigationManager _instance = NavigationManager._();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  /// Getter for navigation manager instance
  static NavigationManager get instance => _instance;

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  final List<Page<dynamic>> _pages = <Page<dynamic>>[];

  @override
  ScreenConfig? get currentConfiguration =>
      _pages.last.arguments as ScreenConfig?;

  @override
  Widget build(BuildContext context) => Navigator(
        key: navigatorKey,
        onPopPage: _onPopPage,
        pages: List<Page<dynamic>>.of(_pages),
      );

  @override
  Future<void> setInitialRoutePath(ScreenConfig configuration) async =>
      setNewRoutePath(configuration);

  @override
  Future<void> setNewRoutePath(ScreenConfig configuration) async {
    _pages.clear();
    addPage(configuration);
  }

  /// Adds a new page to the current page path.
  void addPage(ScreenConfig newScreen) {
    if (_canAdd(newScreen)) _addPageHelper(newScreen);
  }

  /// Replaces the last page with the given new one.
  void replacePage(ScreenConfig newScreen) {
    if (_canAdd(newScreen)) {
      _pages.removeLast();
      _addPageHelper(newScreen);
    }
  }

  bool _canAdd(ScreenConfig newScreen) {
    if (_pages.isEmpty) return true;
    return (_pages.last.arguments as ScreenConfig?)?.path != newScreen.path;
  }

  void _addPageHelper(ScreenConfig newScreen) {
    _pages.add(MaterialPage<dynamic>(
      child: newScreen.builder(),
      key: Key(newScreen.path) as LocalKey,
      name: newScreen.path,
      arguments: newScreen,
    ));
    notifyListeners();
  }

  /// Removes all pages until there is left one (initial) page.
  void popUntilOneLeft() {
    if (_pages.isEmpty) return;
    _pages.removeRange(1, _pages.length);
    notifyListeners();
  }

  /// Removes the pages until the specified page.
  /// Returns [bool] to indicate whether can be popped or not.
  bool popUntil(ScreenConfig untilScreen) {
    final int pageIndex = _pages
        .indexWhere((Page<dynamic> screen) => screen.name == untilScreen.path);
    if (_pages.isEmpty || pageIndex == -1) return false;
    _pages.removeRange(pageIndex + 1, _pages.length);
    notifyListeners();
    return true;
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    final bool didPop = route.didPop(result);
    if (!didPop) return false;
    _pages.remove(route.settings);
    notifyListeners();
    return true;
  }

  @override
  Future<bool> popRoute() async {
    if (_canPop) {
      _pages.removeLast();
      notifyListeners();
      return true;
    }
    return false;
  }

  bool get _canPop => _pages.length > 1;
}
