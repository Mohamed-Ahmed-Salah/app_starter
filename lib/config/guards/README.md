# Permission Guard System

Laravel-style permission and role guards for Flutter widgets.

## Quick Start

```dart
import 'package:attendance/core/widgets/guards/guards.dart';
import 'package:attendance/core/constants/permission_constants.dart';
```

## Usage Examples

### 1. AccessGuard - Combined Permission AND Role Check (Most Flexible)

**NEW!** Use when you want to check BOTH permissions OR roles in a single widget.

```dart
// Show if user has permission OR role (maximum flexibility)
AccessGuard(
  permissions: [PermissionConstants.userManage],
  roles: [RoleConstants.admin, RoleConstants.supervisor],
  child: ManageUsersButton(),
)

// Show if user has ANY of these permissions OR ANY of these roles
AccessGuard(
  permissions: [
    PermissionConstants.attendanceManage,
    PermissionConstants.leaveManage,
  ],
  roles: [RoleConstants.admin],
  child: ManagerDashboard(),
  fallback: Text('Access denied'),
)

// Permission-only check (same as PermissionGuard)
AccessGuard(
  permissions: [PermissionConstants.userManage],
  child: AdminPanel(),
)

// Role-only check (same as RoleGuard)
AccessGuard(
  roles: [RoleConstants.admin],
  child: AdminPanel(),
)
```

### 2. PermissionGuard - Show/Hide Widgets

```dart
// Show button only if user has permission
PermissionGuard(
  permissions: [PermissionConstants.userManage],
  child: ElevatedButton(
    onPressed: () => navigateToUserManagement(),
    child: Text('Manage Users'),
  ),
)

// With fallback message
PermissionGuard(
  permissions: [PermissionConstants.userManage],
  child: ManageUsersButton(),
  fallback: Text('You need user management permission'),
)

// Require ALL permissions (AND logic)
PermissionGuard(
  permissions: [
    PermissionConstants.userManage,
    PermissionConstants.departmentManage,
  ],
  hasAll: true,
  child: AdminPanel(),
)

// Check ANY permission (OR logic - default)
PermissionGuard(
  permissions: [
    PermissionConstants.userManage,
    PermissionConstants.leaveManage,
    PermissionConstants.attendanceManage,
  ],
  child: ManagerDashboard(),
)
```

### 2. RoleGuard - Show/Hide by Role

```dart
// Show only for admin
RoleGuard(
  roles: [RoleConstants.admin],
  child: AdminPanel(),
)

// Show for admin OR supervisor (default OR logic)
RoleGuard(
  roles: RoleConstants.managementRoles,
  child: ManagementTools(),
)

// With fallback
RoleGuard(
  roles: [RoleConstants.admin],
  child: DeleteButton(),
  fallback: Text('Admin only feature'),
)
```

### 3. PermissionButton - Disabled State

```dart
// Button disabled if user lacks permission
PermissionButton(
  permissions: [PermissionConstants.userCreate],
  onPressed: () => createUser(),
  child: Text('Create User'),
)

// Check multiple permissions with ALL mode
PermissionButton(
  permissions: [
    PermissionConstants.userManage,
    PermissionConstants.departmentManage,
  ],
  hasAll: true,
  onPressed: () => assignUserToDepartment(),
  child: Text('Assign to Department'),
)

// IconButton variant
PermissionIconButton(
  permissions: [PermissionConstants.userDelete],
  onPressed: () => deleteUser(),
  icon: Icon(Icons.delete),
  tooltip: 'Delete User',
)

// OutlinedButton variant
PermissionOutlinedButton(
  permissions: [PermissionConstants.leaveApprove],
  onPressed: () => approveLeave(),
  child: Text('Approve'),
)
```

### 4. RoleButton

```dart
RoleButton(
  roles: [RoleConstants.admin],
  onPressed: () => navigateToAdminPanel(),
  child: Text('Admin Panel'),
)
```

### 5. Nested Guards

```dart
// Complex permission logic
PermissionGuard(
  permissions: [PermissionConstants.attendanceManage],
  child: Column(
    children: [
      // Show approve button only if has leave.manage too
      PermissionGuard(
        permissions: [PermissionConstants.leaveManage],
        child: ElevatedButton(
          onPressed: () => approveLeave(),
          child: Text('Approve Leave'),
        ),
      ),

      // Show location button only if has location.manage
      PermissionGuard(
        permissions: [PermissionConstants.locationManage],
        child: ElevatedButton(
          onPressed: () => manageLocations(),
          child: Text('Manage Locations'),
        ),
      ),
    ],
  ),
)

// Role + Permission check
RoleGuard(
  roles: [RoleConstants.admin],
  child: PermissionGuard(
    permissions: [
      PermissionConstants.userManage,
      PermissionConstants.roleManage,
    ],
    hasAll: true,
    child: SuperAdminPanel(),
  ),
)
```

### 6. ListView with Guards

```dart
ListView(
  children: [
    // Always visible
    ListTile(
      title: Text('My Profile'),
      onTap: () => viewProfile(),
    ),

    // Only for users with permission
    PermissionGuard(
      permissions: [PermissionConstants.userManage],
      child: ListTile(
        title: Text('Manage Users'),
        onTap: () => context.go('/users'),
      ),
    ),

    // Only for admins
    RoleGuard(
      roles: [RoleConstants.admin],
      child: ListTile(
        title: Text('Admin Panel'),
        onTap: () => context.go('/admin'),
      ),
    ),

    // Only for managers
    RoleGuard(
      roles: RoleConstants.managementRoles,
      child: ListTile(
        title: Text('Reports'),
        onTap: () => context.go('/reports'),
      ),
    ),
  ],
)
```

## Widget Parameters

### Common Parameters

- **`permissions`** / **`roles`**: `List<String>` - Required. List of permissions or roles to check
- **`child`**: `Widget` - Required. Widget to show when user has access
- **`fallback`**: `Widget?` - Optional. Widget to show when user lacks access (defaults to `SizedBox.shrink()`)
- **`hasAll`**: `bool` - Optional. When `true`, requires ALL permissions/roles (AND logic). When `false` (default), requires ANY permission/role (OR logic)

### Guard-Specific Parameters

- **`showLoadingState`**: `bool` - Optional. Show loading indicator while checking permissions (only for guards)

### Button-Specific Parameters

- **`onPressed`**: `VoidCallback` - Required. Callback when button is pressed (only called if has permission)
- **`style`**: `ButtonStyle?` - Optional. Custom button style
- **`icon`**: `Widget?` - Optional. Icon for button (creates `.icon` variant)
- **`tooltip`**: `String?` - Optional. Tooltip text (IconButton only)
- **`color`**: `Color?` - Optional. Icon color (IconButton only)

## Available Permission Groups

Use predefined permission groups from `PermissionConstants`:

```dart
PermissionConstants.allManagementPermissions      // All management perms
PermissionConstants.userManagementPermissions     // User CRUD
PermissionConstants.userDocumentPermissions       // User docs
PermissionConstants.leaveManagerPermissions       // Leave approval/rejection
PermissionConstants.leaveEmployeePermissions      // Leave CRUD for self
PermissionConstants.attendanceManagerPermissions  // Attendance management
PermissionConstants.attendanceEmployeePermissions // Check-in/out
PermissionConstants.adminOnlyPermissions          // Admin-only features
PermissionConstants.basicManagementPermissions    // Supervisor level
```

## Available Role Groups

```dart
RoleConstants.managementRoles  // admin, supervisor, manager
RoleConstants.adminRoles       // admin
RoleConstants.allRoles         // all available roles
```

## Best Practices

1. **Use constants**: Always use `PermissionConstants` and `RoleConstants` instead of hardcoded strings
2. **Default to OR logic**: Most cases need ANY permission (default `hasAll: false`)
3. **Combine guards**: Use nested guards for complex permission logic
4. **Provide fallbacks**: Use `fallback` parameter for better UX
5. **Permission groups**: Use predefined permission groups when checking multiple related permissions

## Integration with GetUserMeCubit

The guard system automatically integrates with `GetUserMeCubit`:

```dart
// Manual checks in code
final cubit = context.read<GetUserMeCubit>();

if (cubit.hasPermission(PermissionConstants.userManage)) {
  // Do something
}

if (cubit.hasPermissions([
  PermissionConstants.userManage,
  PermissionConstants.departmentManage,
], hasAll: true)) {
  // User has both permissions
}

if (cubit.hasRole(RoleConstants.admin)) {
  // User is admin
}
```
