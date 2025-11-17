import 'get_user_me_cubit/get_user_me_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Widget that shows/hides its child based on user permissions
///
/// Example:
/// ```dart
/// PermissionGuard(
///   permissions: ['user.manage'],
///   child: ElevatedButton(...),
///   fallback: Text('No permission'),
/// )
/// ```
class PermissionGuard extends StatelessWidget {
  const PermissionGuard({
    super.key,
    required this.permissions,
    required this.child,
    this.fallback,
    this.hasAll = false,
    this.showLoadingState = false,
  });

  /// List of permissions to check
  final List<String> permissions;

  /// Widget to show if user has permission
  final Widget child;

  /// Widget to show if user doesn't have permission
  /// If null, shows nothing (SizedBox.shrink)
  final Widget? fallback;

  /// Check mode: false = any (OR), true = all (AND)
  final bool hasAll;

  /// Whether to show loading state while checking permissions
  final bool showLoadingState;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUserMeCubit, GetUserMeState>(
      builder: (context, state) {
        return state.maybeWhen(
          ///we wont be handling loading for each widget and it will be handled at to level home page
          orElse: () => fallback ?? const SizedBox.shrink(),
          success: (userMe) {
            final hasAccess = userMe.hasPermissions(
              permissions,
              hasAll: hasAll,
            );

            return hasAccess ? child : (fallback ?? const SizedBox.shrink());
          },
        );
      },
    );
  }
}
