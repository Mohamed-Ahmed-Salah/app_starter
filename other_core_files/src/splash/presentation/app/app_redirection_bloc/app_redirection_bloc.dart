import 'dart:io';

import 'package:attendance/core/config/enums.dart';
import 'package:attendance/core/services/cache_service.dart';
import 'package:attendance/core/services/firebase_remote_config_service.dart';
import 'package:attendance/core/services/injection_container.dart';
import 'package:attendance/core/utils/util_functions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../../../domain/usecases/get_min_version.dart';

part 'app_redirection_event.dart';

part 'app_redirection_state.dart';

part 'app_redirection_bloc.freezed.dart';

class AppRedirectionBloc
    extends Bloc<AppRedirectionEvent, AppRedirectionState> {
  final CacheService _cacheService;
  final GetMinVersionUsecases _getMinVersionUseCase;

  AppRedirectionBloc({
    required CacheService cacheService,
    required GetMinVersionUsecases getMinVersionUseCase,
  }) : _cacheService = cacheService,
       _getMinVersionUseCase = getMinVersionUseCase,
       super(const AppRedirectionState.initial()) {
    on<GetAppData>(_getAppData);
    on<GetAppDataAndRedirect>(_getAppDataAndRedirect);
  }

  Future<void> _getAppData(event, emit) async {}

  Future<void> fetchData() async {
    ///todo get app data and check for min version or
    await splashInit();
    // final String organizationId=await sl<CacheService>().getOrganizationId();
    // await sl<FirebaseRemoteConfigService>().initialize(organizationId:organizationId);

    // await Future.delayed(Duration(seconds: 4));
  }

  Future<void> _getAppDataAndRedirect(event, emit) async {
    final bool isFirstTime = _cacheService.isFirstTime();
    _clearDirCache();
    await fetchData();

    /// Checking if its force update
    /// if yes go to force update page
    final MinVersionForceUpdate minVersion = await checkAppVersion();

    switch (minVersion) {
      case MinVersionForceUpdate.update:
        emit(AppRedirectionState.successForceUpdate());
      case MinVersionForceUpdate.okay:
        {
          // TODO

          /// emit(AppRedirectionState.successForceUpdate());
          /// if not continue bellow
          if (isFirstTime) {
            emit(AppRedirectionState.successOnboarding());
          } else {
            /// we're not in update or first time so lets check token to nav to auth/home based on token
            final String? sessionToken = await _cacheService.getSessionToken();
            if (sessionToken == null) {
              emit(AppRedirectionState.successNotLoggedIn());
            } else {
              emit(AppRedirectionState.successLoggedIn());
            }
          }
        }
      case MinVersionForceUpdate.couldNotFetch:
        emit(AppRedirectionState.failed(message: ""));
    }
  }

  ///this is to delete anything from cache if user took a picture/document or whatever
  ///and we didn't remove it after it's use..
  /// prevent unnecessary storage usage!
  Future<void> _clearDirCache() async {
    // Clear cache directory on startup
    try {
      final cacheDir = await getTemporaryDirectory();
      if (cacheDir.existsSync()) {
        final files = cacheDir.listSync();
        for (var file in files) {
          if (file is File) {
            await file.delete();
          }
        }
      }
    } catch (e) {
      // debugPrint('Error clearing cache: $e');
    }
    // try {
    //   final cacheDir = await getTemporaryDirectory();
    //   for (var file in cacheDir.listSync()) {
    //     print("DELETING FILE SPALSH ${file.path}");
    //     await file.delete(recursive: true);
    //   }
    //
    //   // if (cacheDir.existsSync()) {
    //   //   await cacheDir.delete(recursive: true);
    //   //   cacheDir.create(); // Recreate empty directory
    //   // }
    // } catch (e) {
    //   // Handle errors gracefully - don't crash the app if cleanup fails
    //   // print('Error clearing cache: $e');
    // }
    // final cacheDir = await getTemporaryDirectory();
    // if (cacheDir.existsSync()) {
    //   cacheDir.deleteSync(recursive: true);
    // }
  }

  Future<MinVersionForceUpdate> checkAppVersion() async {
    // 1. Get min version from Firebase Remote Config
    final String? minVersion = Platform.isIOS
        ? sl<FirebaseRemoteConfigService>().getIosMinVersion()
        : sl<FirebaseRemoteConfigService>().getAndroidMinVersion();

    // : sl<FirebaseRemoteConfigService>().getAndroidMinVersion();

    UtilFunctions.appLog("Min VERSIOM $minVersion");
    if (minVersion == null) {
      // No minimum version specified, skip check
      return MinVersionForceUpdate.couldNotFetch;
    }

    // 2. Get current app version
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String currentVersion = packageInfo.version; // e.g., "1.2.3"

    // 3. Compare versions
    if (_isVersionLower(currentVersion, minVersion)) {
      // Current app is lower than minimum required version
      // Take action: show update dialog, block access, etc.
      UtilFunctions.appLog(
        "Update required! Current: $currentVersion, Minimum: $minVersion",
      );
      return MinVersionForceUpdate.update;
    } else {
      UtilFunctions.appLog("App is up-to-date");

      return MinVersionForceUpdate.okay;
    }
  }

  // Helper to compare versions like "1.2.3"
  bool _isVersionLower(String current, String min) {
    final currentParts = current.split('.').map(int.parse).toList();
    final minParts = min.split('.').map(int.parse).toList();

    for (int i = 0; i < minParts.length; i++) {
      if (i >= currentParts.length) {
        return true; // current version has fewer parts
      }
      if (currentParts[i] < minParts[i]) return true;
      if (currentParts[i] > minParts[i]) return false;
    }
    return false; // versions are equal or current >= min
  }
}
