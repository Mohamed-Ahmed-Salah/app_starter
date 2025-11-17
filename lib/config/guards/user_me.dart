class UserMe {
  final String roleName;
  final List<String> permissions;

  const UserMe({
    required this.roleName,
    required this.permissions,
  });

  /// Check if user has a specific permission
  bool hasPermission(String permission) {
    return permissions.contains(permission);
  }

  /// Check if user has any of the given permissions
  bool hasAnyPermission(List<String> permissionList) {
    return permissionList.any((permission) => permissions.contains(permission));
  }

  /// Check if user has all of the given permissions
  bool hasAllPermissions(List<String> permissionList) {
    return permissionList.every(
      (permission) => permissions.contains(permission),
    );
  }

  /// Check permissions with hasAll flag
  /// If hasAll is true, user must have ALL permissions (AND logic)
  /// If hasAll is false, user must have ANY permission (OR logic) - default
  bool hasPermissions(
    List<String> permissionList, {
    bool hasAll = false,
  }) {
    if (permissionList.isEmpty) return false;

    return hasAll
        ? hasAllPermissions(permissionList)
        : hasAnyPermission(permissionList);
  }

  /// Check if user has a specific role
  bool hasRole(String role) {
    return roleName.toLowerCase() == role.toLowerCase();
  }

  /// Check if user has any of the given roles
  bool hasAnyRole(List<String> roles) {
    return roles.any(
      (role) => roleName.toLowerCase() == role.toLowerCase(),
    );
  }

  /// Check if user matches roles
  /// For single-role systems, this checks if the role is in the list
  bool hasRoles(
    List<String> roles, {
    bool hasAll = false,
  }) {
    if (roles.isEmpty) return false;

    // Since user has single role, both modes check if role is in the list
    // This is for consistency with permissions API
    return hasAnyRole(roles);
  }

  UserMe copyWith({
    String? roleName,
    List<String>? permissions,
  }) =>
      UserMe(
        roleName: roleName ?? this.roleName,
        permissions: permissions ?? this.permissions,
      );
}
