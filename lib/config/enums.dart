
enum NotificationType {
  checkoutReminder,    // Navigate to check-in/out screen
  leaveApproved,       // Navigate to leave history
  leavePending,        // Navigate to pending leaves
  attendanceAlert,     // Navigate to attendance history
  general;             // No navigation, just show notification

  static NotificationType fromString(String? value) {
    return NotificationType.values.firstWhere(
          (e) => e.name == value,
      orElse: () => NotificationType.general,
    );
  }
}