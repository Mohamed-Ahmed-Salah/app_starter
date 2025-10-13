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

enum RequestType {
  annual,
  condolence,
  hajj,
  marriage,
  medical,
  paternity,
  unpaid,
  hr,
  emergency,
}

enum PaymentType { continues, advanced }

enum HrRequestType { vacation, salary }

/// check if leave or request type is same.... ????
enum LeaveType { annual, sick, emergency, maternity, paternity, unpaid }

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
enum DocumentType { pdf, excel, word, image }

enum EmployeeAccountType { supervisor, employee, client, admin }

enum MinVersionForceUpdate { update, okay, couldNotFetch }


enum CardCompany { amex, visa, master, mada }