part of 'app_redirection_bloc.dart';

@freezed
sealed class AppRedirectionEvent with _$AppRedirectionEvent {
  const factory AppRedirectionEvent.getAppDataAndRedirect() = GetAppDataAndRedirect;

  const factory AppRedirectionEvent.getAppData() = GetAppData;
}