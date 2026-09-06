import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/util_functions.dart';
import 'analytics_facade.dart';

class MyGoRouterObserver extends NavigatorObserver {
  MyGoRouterObserver(this._analytics);

  final AnalyticsFacade _analytics;

  /// The location go_router is currently showing.
  ///
  /// [location] is the resolved URL (e.g. `/brands/loreal`) and [template] is
  /// its path pattern (e.g. `/brands/:slug`). We read these from go_router's
  /// live state rather than `route.settings.name`, because that name is only
  /// the route's own segment (`:slug`) for an unnamed nested route and a hash
  /// (`755593900`) for an imperatively-pushed route — never the full path.
  ({String location, String? template})? _current() {
    final context = navigator?.context;
    if (context == null) return null;
    try {
      final state = GoRouter.of(context).state;
      return (location: state.uri.path, template: state.fullPath);
    } catch (_) {
      // No GoRouter in scope (e.g. a bare Navigator.push) — fall back to names.
      return null;
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    final current = _current();
    final customParams = _getArgs(route.settings.arguments);
    _logNavigation(
      current?.template ?? route.settings.name,
      'push',
      customParams,
    );

    UtilFunctions.appLog(
      'PUSHED route: ${current?.template}  ${current?.location ?? route.settings.name}',
    );
    UtilFunctions.appLog('Previous route: ${previousRoute?.settings.name}');
  }

  Map<String, Object?>? _getArgs(Object? args) {
    Map<String, Object?>? customParams;

    if (args is Map<String, Object?>) {
      customParams = args;
    }
    return customParams;
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    UtilFunctions.appLog('POPPED route: ${route.settings.name}');
    UtilFunctions.appLog(
      'Back to route: ${_current()?.location ?? previousRoute?.settings.name}',
    );
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    UtilFunctions.appLog('REMOVED route: ${route.settings.name}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    final current = _current();
    final customParams = _getArgs(newRoute?.settings.arguments);

    _logNavigation(
      current?.template ?? newRoute?.settings.name,
      'replace',
      customParams,
    );
    UtilFunctions.appLog(
      'REPLACED ${oldRoute?.settings.name} with '
      '${current?.location ?? newRoute?.settings.name}',
    );
  }

  void _logNavigation(
    String? routeName,
    String action,
    Map<String, Object?>? args,
  ) {
    if (routeName != null) {
      _analytics.trackScreenView(routeName, action, args);
    } else {
      UtilFunctions.appLog('Route name is missing');
    }
  }
}
