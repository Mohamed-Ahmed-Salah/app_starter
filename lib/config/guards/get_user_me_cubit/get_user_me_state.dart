part of 'get_user_me_cubit.dart';

@freezed
sealed class GetUserMeState with _$GetUserMeState {
  const factory GetUserMeState.initial() = _initialState;

  const factory GetUserMeState.loading() = _loadingState;

  const factory GetUserMeState.failed({
    required String message,
  }) = _failedState;

  const factory GetUserMeState.success({
    required UserMe userMe,
  }) = _successState;
}
