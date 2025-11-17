import 'get_user_me_cubit/get_user_me_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Helper class that conditionally includes items in lists based on user permissions OR roles
///
/// This class was created specifically for PopupMenuButton and other classes that only accept
/// specific list of X widget example: PopupMenuButton needs list of PopupMenuItem.
///
/// Returns a list containing the item if user has access, or empty list if not.
/// Use with spread operator to conditionally add items to any list type.
///
/// If user has ANY of the specified permissions OR ANY of the specified roles,
/// the item is included. This provides maximum flexibility for access control.
///
/// Example with PopupMenuButton:
/// ```dart
/// PopupMenuButton<String>(
///   itemBuilder: (context) => [
///     ...GuardedWidget.build(
///       context: context,
///       permissions: [PermissionConstants.departmentManage],
///       roles: [RoleConstants.admin],
///       child: PopupMenuItem(
///         value: 'edit',
///         child: Text('Edit'),
///       ),
///     ),
///   ],
/// )
/// ```
///
/// Example with Column/ListView:
/// ```dart
/// Column(
///   children: [
///     Text('Always visible'),
///     ...GuardedWidget.build(
///       context: context,
///       permissions: [PermissionConstants.userManage],
///       roles: [RoleConstants.admin],
///       child: ElevatedButton(
///         onPressed: () {},
///         child: Text('Admin Only Button'),
///       ),
///     ),
///   ],
/// )
/// ```
///
/// The child will be shown if:
/// - User has ANY of the specified permissions OR
/// - User has ANY of the specified roles
class GuardedWidgetList {
  /// Returns a list containing the item if user has access, or empty list if not
  /// Use with spread operator: [...GuardedWidget.build(...)]
  ///
  /// Generic type T allows this to work with any type:
  /// - Widget for normal lists (Column, ListView, etc.)
  /// - PopupMenuEntry<String> for PopupMenuButton
  /// - Any other list type you need
  static List<T> build<T>({
    required BuildContext context,
    required List<String> permissions,
    required List<String> roles,
    required T child,
  }) {
    assert(
      permissions.isNotEmpty || roles.isNotEmpty,
      'Must have at least one permission or role to check',
    );

    final userMe = context.read<GetUserMeCubit>().state.maybeWhen(
      success: (user) => user,
      orElse: () => null,
    );

    if (userMe == null) return [];

    bool hasAccess = false;

    // Check permissions
    if (permissions.isNotEmpty) {
      hasAccess = userMe.hasAnyPermission(permissions);
    }

    // Check roles
    if (!hasAccess && roles.isNotEmpty) {
      hasAccess = userMe.hasAnyRole(roles);
    }

    return hasAccess ? [child] : [];
  }
}
