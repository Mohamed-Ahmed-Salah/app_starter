import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/constants/size_constants.dart';
import '../../../../core/services/firebase_remote_config_service.dart';
import '../../../../core/services/injection_container.dart';
import '../../../../core/utils/util_functions.dart';
import '../../../../l10n/app_localizations.dart';

/// Blocks the app when the installed version is below the remote-config
/// minimum. Top-level route with no way back: the only action is the store.
class ForceUpdateView extends StatelessWidget {
  const ForceUpdateView({super.key});

  static const String path = '/force-update';
  static const String name = 'force-update';

  void _openStore() {
    final remoteConfig = sl<FirebaseRemoteConfigService>();
    final url = Platform.isIOS
        ? remoteConfig.getIosUpdateUrl()
        : remoteConfig.getAndroidUpdateUrl();
    if (url != null && url.isNotEmpty) UtilFunctions.openExternalUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = AppLocalizations.of(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(SizeConstants.screenPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                text?.updateRequiredTitle ?? 'Update required',
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: SizeConstants.itemGap),
              Text(
                text?.updateRequiredBody ??
                    'This version is no longer supported. Please update to continue.',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: SizeConstants.sectionGap),
              ElevatedButton(
                onPressed: _openStore,
                child: Text(text?.updateNow ?? 'Update now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
