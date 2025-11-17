import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'get_user_me_cubit/get_user_me_cubit.dart';

/// Widget that shows/hides its child based on user role
///
/// Example:
/// ```dart
/// RoleGuard(
///   roles: ['admin', 'supervisor'],
///   child: AdminPanel(),
///   fallback: Text('Admins only'),
/// )
/// ```
class RoleGuard extends StatelessWidget {
  const RoleGuard({
    super.key,
    required this.roles,
    required this.child,
    this.fallback,
    this.hasAll = false,
    this.showLoadingState = false,
  });

  /// List of roles to check
  final List<String> roles;

  /// Widget to show if user has role
  final Widget child;

  /// Widget to show if user doesn't have role
  /// If null, shows nothing (SizedBox.shrink)
  final Widget? fallback;

  /// Check mode: false = any (OR), true = all (AND)
  /// Note: For single-role systems, only 'any' makes practical sense
  final bool hasAll;

  /// Whether to show loading state while checking roles
  final bool showLoadingState;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUserMeCubit, GetUserMeState>(
      builder: (context, state) {
        return state.when(
          initial: () => fallback ?? const SizedBox.shrink(),
          loading: () => showLoadingState
              ? const Center(child: CircularProgressIndicator())
              : (fallback ?? const SizedBox.shrink()),
          failed: (message) => fallback ?? const SizedBox.shrink(),
          success: (userMe) {
            final hasAccess = userMe.hasRoles(roles, hasAll: hasAll);

            return hasAccess ? child : (fallback ?? const SizedBox.shrink());
          },
        );
      },
    );
  }
}
