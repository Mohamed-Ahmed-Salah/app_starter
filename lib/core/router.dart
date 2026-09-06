import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../src/auth/presentation/views/login_view.dart';
import '../src/force_update/presentation/view/force_update_view.dart';
import '../src/home/presentation/view/home_view.dart';
import '../src/language/presentation/view/language_view.dart';
import '../src/onboarding/presentation/view/onboarding_view.dart';
import '../src/products/presentation/view/products_view.dart';
import '../src/splash/presentation/view/splash_view.dart';
import 'monitoring/analytics_facade.dart';
import 'monitoring/routing_observer.dart';
import 'services/injection_container.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

GlobalKey<ScaffoldMessengerState> get scaffoldKey => _scaffoldKey;

/// Every view declares `static const path` (and `name` for nested routes) and
/// is registered here. Tab shells go in a `StatefulShellRoute.indexedStack`;
/// routes that must sit above the shell pass `parentNavigatorKey:
/// _rootNavigatorKey`.
final router = GoRouter(
  debugLogDiagnostics: true,
  navigatorKey: _rootNavigatorKey,
  initialLocation: SplashView.path,
  observers: [MyGoRouterObserver(sl<AnalyticsFacade>())],
  routes: [
    GoRoute(
      path: SplashView.path,
      name: SplashView.name,
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: ForceUpdateView.path,
      name: ForceUpdateView.name,
      builder: (context, state) => const ForceUpdateView(),
    ),
    GoRoute(
      path: OnboardingView.path,
      name: OnboardingView.name,
      builder: (context, state) => const OnboardingView(),
    ),
    GoRoute(
      path: LoginView.path,
      name: LoginView.name,
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: HomeView.path,
      name: HomeView.name,
      builder: (context, state) => const HomeView(),
      routes: [
        GoRoute(
          path: ProductsView.name,
          name: ProductsView.name,
          builder: (context, state) => const ProductsView(),
        ),
        GoRoute(
          path: LanguageView.name,
          name: LanguageView.name,
          builder: (context, state) => const LanguageView(),
        ),
      ],
    ),
  ],
);
