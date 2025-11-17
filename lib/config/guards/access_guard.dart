import 'get_user_me_cubit/get_user_me_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Widget that shows/hides its child based on user permissions OR roles
///
/// If user has ANY of the specified permissions OR ANY of the specified roles,
/// the child is shown. This provides maximum flexibility for access control.
///
/// Example:
/// ```dart
/// AccessGuard(
///   permissions: [PermissionConstants.userManage],
///   roles: [RoleConstants.admin],
///   child: AdminButton(),
///   fallback: Text('Access denied'),
/// )
/// ```
///
/// The child will be shown if:
/// - User has 'user.manage' permission OR
/// - User has 'admin' role
class AccessGuard extends StatelessWidget {
  const AccessGuard({
    super.key,
    required this.permissions,
    required this.roles,
    required this.child,
    this.fallback,
    this.showLoadingState = false,
  }) : assert(
         permissions.length > 0 || roles.length > 0,
         'AccessGuard must have at least one permission or role to check',
       );

  /// List of permissions to check (OR logic)
  final List<String> permissions;

  /// List of roles to check (OR logic)
  final List<String> roles;

  /// Widget to show if user has access
  final Widget child;

  /// Widget to show if user doesn't have access
  /// If null, shows nothing (SizedBox.shrink)
  final Widget? fallback;

  /// Whether to show loading state while checking access
  final bool showLoadingState;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUserMeCubit, GetUserMeState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => fallback ?? const SizedBox.shrink(),
          success: (userMe) {
            bool hasAccess = false;

            // Check permissions (if any specified)
            if (permissions.isNotEmpty) {
              hasAccess = userMe.hasAnyPermission(permissions);
            }

            // Check roles (if any specified and not already has access)
            if (!hasAccess && roles.isNotEmpty) {
              hasAccess = userMe.hasAnyRole(roles);
            }

            return hasAccess ? child : (fallback ?? const SizedBox.shrink());
          },
        );
      },
    );
  }
}
