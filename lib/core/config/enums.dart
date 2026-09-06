///used in onboarding. we have more permissions to save images/files
enum PermissionType { camera, location, notification }

///location Permission used in location helper that checks user location
enum LocationPermissionStatus { success, rejected, notAvailable }

enum MinVersionForceUpdate { update, okay, couldNotFetch }

enum NotificationType {
  notification('notifications'),
  general('general');

  final String value;

  const NotificationType(this.value);

  static NotificationType fromString(String? value) {
    if (value == null || value.isEmpty) return NotificationType.general;

    return NotificationType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => NotificationType.general,
    );
  }
}
