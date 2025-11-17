
import 'package:app_starter/config/guards/user_me.dart';
import 'package:app_starter/config/network/mixins/failure_popups.dart';
import 'package:app_starter/config/utils/util_functions.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_user_me_state.dart';
part 'get_user_me_cubit.freezed.dart';

class GetUserMeCubit extends Cubit<GetUserMeState> with FailurePopups {
  final GetUserMeUsecase _getUserMeUsecase;

  GetUserMeCubit({
    required GetUserMeUsecase getUserMeUsecase,
  })  : _getUserMeUsecase = getUserMeUsecase,
        super(const GetUserMeState.initial());

  /// Fetch current user's role and permissions
  ///
  /// Parameters:
  /// - isEn: Language flag for error messages
  Future<void> getUserMe({required bool isEn}) async {
    UtilFunctions.appLog("getUserMe: Fetching user role and permissions");
    emit(const GetUserMeState.loading());

    // Call the use case
    final result = await _getUserMeUsecase();

    result.fold(
      (failure) {
        final message = getFailureMessage(failure, isEn);
        emit(GetUserMeState.failed(message: message));
      },
      (userMe) {
        UtilFunctions.appLog("getUserMe: Success - Role: ${userMe.roleName}");
        UtilFunctions.appLog("getUserMe: Permissions: ${userMe.permissions}");
        emit(GetUserMeState.success(userMe: userMe));
      },
    );
  }

  /// Check if user has a specific permission
  bool hasPermission(String permission) {
    return state.maybeWhen(
      success: (userMe) => userMe.hasPermission(permission),
      orElse: () => false,
    );
  }

  Future<void> getUserMeInBackground({required bool isEn}) async {
    UtilFunctions.appLog("getUserMe: Fetching user role and permissions in Background");

    // Call the use case
    final result = await _getUserMeUsecase();

    result.fold(
          (failure) {
        final message = getFailureMessage(failure, isEn);
        emit(GetUserMeState.failed(message: message));
      },
          (userMe) {
        UtilFunctions.appLog("getUserMe: Success - Role: ${userMe.roleName}");
        UtilFunctions.appLog("getUserMe: Permissions: ${userMe.permissions}");
        emit(GetUserMeState.success(userMe: userMe));
      },
    );
  }


  /// Check multiple permissions with hasAll flag
  /// If hasAll is true, user must have ALL permissions (AND logic)
  /// If hasAll is false, user must have ANY permission (OR logic) - default
  bool hasPermissions(
    List<String> permissions, {
    bool hasAll = false,
  }) {
    return state.maybeWhen(
      success: (userMe) => userMe.hasPermissions(permissions, hasAll: hasAll),
      orElse: () => false,
    );
  }

  /// Check if user has a specific role
  bool hasRole(String role) {
    return state.maybeWhen(
      success: (userMe) => userMe.hasRole(role),
      orElse: () => false,
    );
  }

  /// Check multiple roles
  bool hasRoles(
    List<String> roles, {
    bool hasAll = false,
  }) {
    return state.maybeWhen(
      success: (userMe) => userMe.hasRoles(roles, hasAll: hasAll),
      orElse: () => false,
    );
  }

  /// Get current role name, or empty string if not loaded
  String get roleName {
    return state.maybeWhen(
      success: (userMe) => userMe.roleName,
      orElse: () => "",
    );
  }

  /// Get current permissions, or empty list if not loaded
  List<String> get permissions {
    return state.maybeWhen(
      success: (userMe) => userMe.permissions,
      orElse: () => [],
    );
  }

  /// Check if user data is loaded
  bool get isLoaded {
    return state is _successState;
  }

  /// Check if currently loading
  bool get isLoading {
    return state is _loadingState;
  }
}
