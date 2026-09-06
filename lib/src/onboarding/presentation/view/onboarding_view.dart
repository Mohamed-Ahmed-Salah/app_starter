import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/size_constants.dart';
import '../../../../core/services/cache_service.dart';
import '../../../../core/services/injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/views/login_view.dart';

/// Placeholder first-launch screen. Replace the body with the real slides;
/// keep the exit: mark the first launch as seen, then `go` to login.
class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  static const String path = '/onboarding';
  static const String name = 'onboarding';

  Future<void> _finish(BuildContext context) async {
    await sl<CacheService>().cacheFirstTimer();
    if (context.mounted) context.go(LoginView.path);
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(SizeConstants.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              text?.onboardingTitle ?? 'Welcome',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SizeConstants.sectionGap),
            ElevatedButton(
              onPressed: () => _finish(context),
              child: Text(text?.getStarted ?? 'Get started'),
            ),
          ],
        ),
      ),
    );
  }
}
