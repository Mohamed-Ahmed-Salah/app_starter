import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../../core/config/enums.dart';
import '../../../../../core/services/cache_service.dart';
import '../../../../../core/services/firebase_remote_config_service.dart';
import '../../../../../core/services/injection_container.dart';
import '../../../../../core/utils/util_functions.dart';

part 'app_redirection_event.dart';
part 'app_redirection_state.dart';
part 'app_redirection_bloc.freezed.dart';

/// Decides the first screen after splash, in this order:
/// force update → onboarding (first launch) → home (has session) → login.
///
/// Provided once, app-wide, from `AppWideProviderRegistry`; the splash view
/// listens and navigates.
@lazySingleton
class AppRedirectionBloc
    extends Bloc<AppRedirectionEvent, AppRedirectionState> {
  AppRedirectionBloc({
    required CacheService cacheService,
    required FirebaseRemoteConfigService firebaseRemoteConfigService,
  }) : _cacheService = cacheService,
       _firebaseRemoteConfigService = firebaseRemoteConfigService,
       super(const AppRedirectionState.initial()) {
    on<GetAppDataAndRedirect>(_getAppDataAndRedirect);
  }

  final CacheService _cacheService;
  final FirebaseRemoteConfigService _firebaseRemoteConfigService;

  Future<void> _getAppDataAndRedirect(
    GetAppDataAndRedirect event,
    Emitter<AppRedirectionState> emit,
  ) async {
    emit(const AppRedirectionState.loading());

    final bool isFirstTime = _cacheService.isFirstTime();
    UtilFunctions.appLog(
      "Is first time and should go to onboarding: $isFirstTime",
    );

    // Push, crash reporting, remote config — needed before the version check.
    await splashInit();

    switch (await _checkAppVersion()) {
      case MinVersionForceUpdate.update:
        emit(const AppRedirectionState.successForceUpdate());
      case MinVersionForceUpdate.couldNotFetch:
        emit(const AppRedirectionState.failed(message: ''));
      case MinVersionForceUpdate.okay:
        if (isFirstTime) {
          emit(const AppRedirectionState.successOnboarding());
          return;
        }
        final token = await _cacheService.getSessionToken();
        if (token != null && token.isNotEmpty) {
          emit(const AppRedirectionState.successLoggedIn());
        } else {
          emit(const AppRedirectionState.successNotLoggedIn());
        }
    }
  }

  Future<MinVersionForceUpdate> _checkAppVersion() async {
    final String? minVersion = Platform.isIOS
        ? _firebaseRemoteConfigService.getIosMinVersion()
        : _firebaseRemoteConfigService.getAndroidMinVersion();

    UtilFunctions.appLog("Min version: $minVersion");
    if (minVersion == null || minVersion.isEmpty) {
      return MinVersionForceUpdate.couldNotFetch;
    }

    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String currentVersion = packageInfo.version; // e.g. "1.2.3"

    if (_isVersionLower(currentVersion, minVersion)) {
      UtilFunctions.appLog(
        "Update required! Current: $currentVersion, Minimum: $minVersion",
      );
      return MinVersionForceUpdate.update;
    }
    UtilFunctions.appLog("App is up-to-date");
    return MinVersionForceUpdate.okay;
  }

  /// `1.2.3` style comparison; a missing trailing part counts as lower.
  bool _isVersionLower(String current, String min) {
    final currentParts = current.split('.').map(int.parse).toList();
    final minParts = min.split('.').map(int.parse).toList();

    for (int i = 0; i < minParts.length; i++) {
      if (i >= currentParts.length) return true;
      if (currentParts[i] < minParts[i]) return true;
      if (currentParts[i] > minParts[i]) return false;
    }
    return false;
  }
}
