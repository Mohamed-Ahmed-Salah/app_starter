/// Permission constants for the attendance system
///
/// This class contains all available permissions organized by category.
/// Use these constants instead of hardcoded strings for type safety.
abstract class PermissionConstants {
  // ==================== User Management ====================
  static const String userManage = 'user.manage';
  static const String userView = 'user.view';
  static const String userViewOthers = 'user.view.others';
  static const String userCreate = 'user.create';
  static const String userUpdate = 'user.update';
  static const String userUpdateOthers = 'user.update.others';
  static const String userDelete = 'user.delete';
  static const String userLock = 'user.lock';
  static const String userUnlock = 'user.unlock';
  static const String userViewStats = 'user.view.stats';

  // User Documents
  static const String userManageDocs = 'user.manage.docs';
  static const String userAddDocs = 'user.add.docs';
  static const String userAddDocsOthers = 'user.add.docs.others';
  static const String userViewDocs = 'user.view.docs';
  static const String userViewDocsOthers = 'user.view.docs.others';
  static const String userDownloadDocs = 'user.download.docs';
  static const String userDownloadDocsOthers = 'user.download.docs.others';
  static const String userDeleteDocs = 'user.delete.docs';
  static const String userDeleteDocsOthers = 'user.delete.docs.others';

  // ==================== Client Management ====================
  static const String clientManage = 'client.manage';
  static const String clientCreate = 'client.create';
  static const String clientUpdate = 'client.update';
  static const String clientDelete = 'client.delete';

  // ==================== Department Management ====================
  static const String departmentManage = 'department.manage';
  static const String departmentCreate = 'department.create';
  static const String departmentUpdate = 'department.update';
  static const String departmentDelete = 'department.delete';
  static const String departmentView = 'department.view';

  // ==================== Location Management ====================
  static const String locationManage = 'location.manage';
  static const String locationView = 'location.view';
  static const String locationCreate = 'location.create';
  static const String locationUpdate = 'location.update';
  static const String locationDelete = 'location.delete';

  // ==================== Leave Management ====================
  static const String leaveManage = 'leave.manage';
  static const String leaveView = 'leave.view';
  static const String leaveViewOthers = 'leave.view.others';
  static const String leaveCreate = 'leave.create';
  static const String leaveCreateOthers = 'leave.create.others';
  static const String leaveUpdate = 'leave.update';
  static const String leaveUpdateOthers = 'leave.update.others';
  static const String leaveDelete = 'leave.delete';
  static const String leaveDeleteOthers = 'leave.delete.others';
  static const String leaveApprove = 'leave.approve';
  static const String leaveReject = 'leave.reject';

  // Leave Type Management
  static const String leaveTypeManage = 'leaveType.manage';
  static const String leaveTypeCreate = 'leaveType.create';
  static const String leaveTypeUpdate = 'leaveType.update';
  static const String leaveTypeDelete = 'leaveType.delete';

  // ==================== Attendance Management ====================
  static const String attendanceManage = 'attendance.manage';
  static const String attendanceView = 'attendance.view';
  static const String attendanceCheckin = 'attendance.checkin';
  static const String attendanceCheckout = 'attendance.checkout';

  // ==================== Role Management ====================
  static const String roleManage = 'role.manage';
  static const String roleView = 'role.view';
  static const String roleCreate = 'role.create';
  static const String roleUpdate = 'role.update';
  static const String roleDelete = 'role.delete';
  static const String roleAssignPerms = 'role.assignPerms';

  // ==================== Permission Groups ====================

  /// All management permissions (super admin level)
  static const List<String> allManagementPermissions = [
    userManage,
    clientManage,
    departmentManage,
    locationManage,
    leaveManage,
    leaveTypeManage,
    attendanceManage,
    roleManage,
  ];

  /// Basic user management permissions
  static const List<String> userManagementPermissions = [
    userManage,
    userView,
    userViewOthers,
    userCreate,
    userUpdate,
    userUpdateOthers,
    userDelete,
  ];

  /// User document permissions
  static const List<String> userDocumentPermissions = [
    userManageDocs,
    userAddDocs,
    userAddDocsOthers,
    userViewDocs,
    userViewDocsOthers,
    userDownloadDocs,
    userDownloadDocsOthers,
    userDeleteDocs,
    userDeleteDocsOthers,
  ];

  /// Leave management permissions (for managers/supervisors)
  static const List<String> leaveManagerPermissions = [
    leaveManage,
    leaveView,
    leaveViewOthers,
    leaveApprove,
    leaveReject,
  ];

  /// Leave employee permissions (for regular employees)
  static const List<String> leaveEmployeePermissions = [
    leaveView,
    leaveCreate,
    leaveUpdate,
    leaveDelete,
  ];

  /// Attendance management permissions
  static const List<String> attendanceManagerPermissions = [
    attendanceManage,
    attendanceView,
  ];

  /// Attendance employee permissions
  static const List<String> attendanceEmployeePermissions = [
    attendanceCheckin,
    attendanceCheckout,
  ];

  /// Admin-only permissions (highest level)
  static const List<String> adminOnlyPermissions = [
    userManage,
    roleManage,
    roleAssignPerms,
    userLock,
    userUnlock,
    userViewStats,
  ];

  /// Basic management permissions (supervisor level)
  static const List<String> basicManagementPermissions = [
    leaveManage,
    attendanceManage,
    locationView,
    departmentManage,
  ];
}

/// Role name constants
abstract class RoleConstants {
  static const String admin = 'super-admin';
  static const String supervisor = 'supervisor';
  static const String employee = 'employee';
  static const String client = 'admin';

  /// Roles that have management capabilities
  static const List<String> managementRoles = [
    admin,
    supervisor,
    client,
  ];

  /// Admin-level roles
  static const List<String> adminRoles = [
    admin,
  ];

  /// All available roles
  static const List<String> allRoles = [
    admin,
    supervisor,
    client,
    employee,
  ];
}
