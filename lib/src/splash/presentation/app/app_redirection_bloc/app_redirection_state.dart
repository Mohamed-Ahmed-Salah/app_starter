part of 'app_redirection_bloc.dart';

@freezed
sealed class AppRedirectionState with _$AppRedirectionState {
  const factory AppRedirectionState.initial() = _initialState;
  const factory AppRedirectionState.loading() = _loadingState;
  const factory AppRedirectionState.failed({required String message}) =
      _failedState;
  const factory AppRedirectionState.successNotLoggedIn() = _notLoggedInState;
  const factory AppRedirectionState.successLoggedIn() = _loggedInState;
  const factory AppRedirectionState.successForceUpdate() = _forceUpdateState;
  const factory AppRedirectionState.successOnboarding() = _onboardingState;
}
