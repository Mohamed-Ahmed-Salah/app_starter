///used in onboarding. we have more permissions to save images/files
enum PermissionType { camera, location, notification }

enum AttendanceType { present, absent, onVacation }

enum AttendanceTimeType { early, late, onTime, na }

enum AttendanceActivityType { checkIn, checkOut, takeBreak }

///similar to AttendanceType but more detailed used in attendance history days...
enum AttendanceDayType {
  sick,
  holiday,
  weekend,
  attended,
  payedLeave,
  missed,
  normal,
}

enum RequestStatus { approved, pending, rejected }



enum PaymentType { continues, advanced }


enum AuthenticationStatus {
  initial,
  authenticating,
  authenticated,
  failed,
  error,
  cancelled,
  notAvailable,
  notEnrolled,
  lockedOut,
  permanentlyLockedOut,
}

enum BiometricCapability { none, available, enrolled }

enum JustificationType { late, fullDay, earlyLeave }

enum AttendanceCheckRequest { checkIn, checkOut, breakIn, breakOut }

// Document type enum
enum DocumentType {
  pdf("application/pdf"),
  excel("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"),
  word("application/vnd.openxmlformats-officedocument.wordprocessingml.document"),
  image("image/png");

  const DocumentType(String name);
}

// enum EmployeeAccountType { supervisor, employee, client, admin }

enum MinVersionForceUpdate { update, okay, couldNotFetch }

enum CardCompany { amex, visa, master, mada }

enum EmergencyContactMedium {
  phone("phone"),
  email("email"),
  whatsapp("whatsapp");

  const EmergencyContactMedium(String name);
}

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

