import 'get_user_me_cubit/get_user_me_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ElevatedButton that's disabled if user lacks permission
///
/// Example:
/// ```dart
/// PermissionButton(
///   permissions: ['user.manage'],
///   onPressed: () => navigateToUserManagement(),
///   child: Text('Manage Users'),
/// )
/// ```
class PermissionButton extends StatelessWidget {
  const PermissionButton({
    super.key,
    required this.permissions,
    required this.onPressed,
    required this.child,
    this.hasAll = false,
    this.style,
    this.icon,
  });

  /// List of permissions required
  final List<String> permissions;

  /// Callback when pressed (only called if has permission)
  final VoidCallback onPressed;

  /// Button content
  final Widget child;

  /// Check mode: false = any (OR), true = all (AND)
  final bool hasAll;

  /// Button style
  final ButtonStyle? style;

  /// Optional icon (makes it ElevatedButton.icon)
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUserMeCubit, GetUserMeState>(
      builder: (context, state) {
        final hasPermission = state.maybeWhen(
          success: (userMe) => userMe.hasPermissions(
            permissions,
            hasAll: hasAll,
          ),
          orElse: () => false,
        );

        final effectiveOnPressed = hasPermission ? onPressed : null;

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

/// OutlinedButton variant
class PermissionOutlinedButton extends StatelessWidget {
  const PermissionOutlinedButton({
    super.key,
    required this.permissions,
    required this.onPressed,
    required this.child,
    this.hasAll = false,
    this.style,
    this.icon,
  });

  final List<String> permissions;
  final VoidCallback onPressed;
  final Widget child;
  final bool hasAll;
  final ButtonStyle? style;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUserMeCubit, GetUserMeState>(
      builder: (context, state) {
        final hasPermission = state.maybeWhen(
          success: (userMe) => userMe.hasPermissions(
            permissions,
            hasAll: hasAll,
          ),
          orElse: () => false,
        );

        final effectiveOnPressed = hasPermission ? onPressed : null;

        if (icon != null) {
          return OutlinedButton.icon(
            onPressed: effectiveOnPressed,
            icon: icon!,
            label: child,
            style: style,
          );
        }

        return OutlinedButton(
          onPressed: effectiveOnPressed,
          style: style,
          child: child,
        );
      },
    );
  }
}

/// IconButton variant
class PermissionIconButton extends StatelessWidget {
  const PermissionIconButton({
    super.key,
    required this.permissions,
    required this.onPressed,
    required this.icon,
    this.hasAll = false,
    this.tooltip,
    this.color,
  });

  final List<String> permissions;
  final VoidCallback onPressed;
  final Widget icon;
  final bool hasAll;
  final String? tooltip;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUserMeCubit, GetUserMeState>(
      builder: (context, state) {
        final hasPermission = state.maybeWhen(
          success: (userMe) => userMe.hasPermissions(
            permissions,
            hasAll: hasAll,
          ),
          orElse: () => false,
        );

        final effectiveOnPressed = hasPermission ? onPressed : null;

        return IconButton(
          onPressed: effectiveOnPressed,
          icon: icon,
          tooltip: tooltip,
          color: hasPermission ? color : Colors.grey,
        );
      },
    );
  }
}
