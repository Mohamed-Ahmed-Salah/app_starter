# AccessGuard Usage Examples

## What is AccessGuard?

`AccessGuard` is a flexible widget that checks BOTH permissions AND roles. If the user has **ANY** of the specified permissions **OR** **ANY** of the specified roles, the child widget is shown.

## Basic Usage

### Example 1: Permission OR Role

```dart
// Show if user has 'user.manage' permission OR 'admin' role
AccessGuard(
  permissions: [PermissionConstants.userManage],
  roles: [RoleConstants.admin],
  child: ElevatedButton(
    onPressed: () => navigateToUserManagement(),
    child: Text('Manage Users'),
  ),
)
```

### Example 2: Multiple Permissions OR Multiple Roles

```dart
// Show if user has ANY of these permissions OR ANY of these roles
AccessGuard(
  permissions: [
    PermissionConstants.attendanceManage,
    PermissionConstants.leaveManage,
  ],
  roles: [
    RoleConstants.admin,
    RoleConstants.supervisor,
  ],
  child: ManagerDashboard(),
)
```

### Example 3: Permission-Only (Like PermissionGuard)

```dart
// Only check permissions, ignore roles
AccessGuard(
  permissions: [PermissionConstants.departmentManage],
  child: DepartmentSettings(),
)
```

### Example 4: Role-Only (Like RoleGuard)

```dart
// Only check roles, ignore permissions
AccessGuard(
  roles: [RoleConstants.admin],
  child: AdminPanel(),
)
```

## Navigation Examples

### Bottom Navigation Item

```dart
// Show Employees tab for users with permission OR supervisors/admins
AccessGuard(
  permissions: [PermissionConstants.attendanceView],
  roles: [RoleConstants.admin, RoleConstants.supervisor],
  child: NavigationButton(
    icon: Icons.people,
    label: 'Employees',
    onTap: () => context.go('/employees'),
  ),
)
```

### Side Menu Item

```dart
// Show Departments menu for users with permission OR admin role
AccessGuard(
  permissions: [PermissionConstants.departmentManage],
  roles: [RoleConstants.admin],
  child: ListTile(
    leading: Icon(Icons.business),
    title: Text('Departments'),
    onTap: () => context.go('/departments'),
  ),
)
```

## Advanced Examples

### With Fallback

```dart
// Show fallback widget if user lacks access
AccessGuard(
  permissions: [PermissionConstants.userManage],
  roles: [RoleConstants.admin],
  child: AdminDashboard(),
  fallback: Text('You need admin access to view this section'),
)
```

### Nested Guards

```dart
// First check if user can view management section
AccessGuard(
  permissions: [PermissionConstants.attendanceManage, PermissionConstants.leaveManage],
  roles: [RoleConstants.admin, RoleConstants.supervisor],
  child: Column(
    children: [
      Text('Management Tools'),

      // Then check specific permission for sub-feature
      AccessGuard(
        permissions: [PermissionConstants.userManage],
        child: UserManagementButton(),
      ),

      AccessGuard(
        permissions: [PermissionConstants.locationManage],
        child: LocationManagementButton(),
      ),
    ],
  ),
)
```

## When to Use What?

| Widget | Use Case |
|--------|----------|
| **AccessGuard** | Need to check BOTH permissions OR roles |
| **PermissionGuard** | Only need to check permissions |
| **RoleGuard** | Only need to check roles |

## Real-World Navigation Example

```dart
ListView(
  children: [
    // Public items - no guard needed
    ListTile(title: Text('Home'), onTap: () => context.go('/')),
    ListTile(title: Text('Profile'), onTap: () => context.go('/profile')),

    // Management section - permission OR role check
    AccessGuard(
      permissions: [
        PermissionConstants.attendanceManage,
        PermissionConstants.leaveManage,
      ],
      roles: [RoleConstants.admin, RoleConstants.supervisor],
      child: ExpansionTile(
        title: Text('Management'),
        children: [
          // Sub-items with specific permission checks
          AccessGuard(
            permissions: [PermissionConstants.attendanceView],
            child: ListTile(
              title: Text('Employees'),
              onTap: () => context.go('/employees'),
            ),
          ),

          AccessGuard(
            permissions: [PermissionConstants.locationManage],
            child: ListTile(
              title: Text('Locations'),
              onTap: () => context.go('/locations'),
            ),
          ),
        ],
      ),
    ),

    // Admin-only section
    AccessGuard(
      roles: [RoleConstants.admin],
      child: ListTile(
        title: Text('Admin Panel'),
        onTap: () => context.go('/admin'),
      ),
    ),
  ],
)
```

## Benefits Over if-else

### Before (with if-else):
```dart
if (userMe.hasPermission(PermissionConstants.attendanceView) ||
    userMe.hasRole(RoleConstants.admin) ||
    userMe.hasRole(RoleConstants.supervisor)) {
  return EmployeesButton();
}
return SizedBox.shrink();
```

### After (with AccessGuard):
```dart
AccessGuard(
  permissions: [PermissionConstants.attendanceView],
  roles: [RoleConstants.admin, RoleConstants.supervisor],
  child: EmployeesButton(),
)
```

**Result**: Cleaner, more declarative, easier to read and maintain!
