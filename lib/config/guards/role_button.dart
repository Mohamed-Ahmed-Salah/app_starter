import 'get_user_me_cubit/get_user_me_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ElevatedButton that's disabled if user lacks role
///
/// Example:
/// ```dart
/// RoleButton(
///   roles: ['admin'],
///   onPressed: () => navigateToAdminPanel(),
///   child: Text('Admin Panel'),
/// )
/// ```
class RoleButton extends StatelessWidget {
  const RoleButton({
    super.key,
    required this.roles,
    required this.onPressed,
    required this.child,
    this.hasAll = false,
    this.style,
    this.icon,
  });

  final List<String> roles;
  final VoidCallback onPressed;
  final Widget child;
  final bool hasAll;
  final ButtonStyle? style;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUserMeCubit, GetUserMeState>(
      builder: (context, state) {
        final hasRole = state.maybeWhen(
          success: (userMe) => userMe.hasRoles(roles, hasAll: hasAll),
          orElse: () => false,
        );

        final effectiveOnPressed = hasRole ? onPressed : null;

        if (icon != null) {
          return ElevatedButton.icon(
            onPressed: effectiveOnPressed,
            icon: icon!,
            label: child,
            style: style,
          );
        }

        return ElevatedButton(
          onPressed: effectiveOnPressed,
          style: style,
          child: child,
        );
      },
    );
  }
}
