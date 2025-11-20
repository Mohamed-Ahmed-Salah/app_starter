import 'dart:async';
import 'dart:io';

import 'package:attendance/core/utils/util_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart'; // Handles location services
import 'package:geocoding/geocoding.dart'; // Converts coordinates to human-readable addresses
import 'package:permission_handler/permission_handler.dart';

enum LocationPermissionCus { success, rejected, notAvailable }

///todo remove change notifier from here... and remove the call back function.
/// A helper class for handling location services
class LocationHelper with ChangeNotifier {
  String userLocation = ''; // Stores the location data

  ///distance in meter to update the location
  static const int _minDistanceToUpdate = 50;

  /// Requests location permission and retrieves the user's location along with city & country details.
  static Future<Map<String, dynamic>?> _getUserLocation(
    Position position,
  ) async {
    try {
      // ✅ Step 5: Convert latitude & longitude to an address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // ✅ Step 6: Extract city and country details from the retrieved placemarks
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first; // Use the first result
        final ob = {
          'latitude': position.latitude,
          // User's latitude
          'longitude': position.longitude,
          // User's longitude
          'city': place.locality ?? 'Unknown',
          // City name (if available)
          'country': place.country ?? 'Unknown',
          // Country name (if available)
          'address': '${place.street}, ${place.locality}, ${place.country}',
          "isMocked": "${position.isMocked}",
          // Full address
        };
        UtilFunctions.appLog(ob.toString());
        return ob;
      }
      return null; // If no placemark data is found, return null
    } catch (e) {
      UtilFunctions.appLog(
        'Error getting location: $e',
      ); // Handle any errors that occur
      return null;
    }
  }

  static Future<LocationPermissionCus> _requestPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // ✅ Step 1: Check if location services are enabled on the device
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    UtilFunctions.appLog("isLocationServiceEnabled $serviceEnabled");

    if (!serviceEnabled) {
      return LocationPermissionCus
          .notAvailable; // If location services are off, return null
    }

    // ✅ Step 2: Check the current location permission status
    permission = await Geolocator.checkPermission();
    UtilFunctions.appLog("permission $permission");

    if (permission == LocationPermission.denied) {
      // If permission is denied, request it again
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationPermissionCus
            .rejected; // If location services are off, return null
        // If denied again, return null
      }
    }

    // ✅ Step 3: Check if the user has permanently denied location access
    if (permission == LocationPermission.deniedForever) {
      return LocationPermissionCus
          .rejected; // Cannot proceed without location permissions
    }
    if (permission == LocationPermission.always) {
      return LocationPermissionCus.success;
    }
    if (permission == LocationPermission.whileInUse) {
      final PermissionStatus status =
          await UtilFunctions.requestLocationAlwaysInBackgroundPermission();
      final bool success = status.isGranted;
      UtilFunctions.appLog("await Future.delayed(Duration(seconds: 4));");

      await Future.delayed(Duration(seconds: 4));
      UtilFunctions.appLog(
        "success of requestLocationAlwaysInBackgroundPermission in location  $permission",
      );

      return success
          ? LocationPermissionCus.success
          : LocationPermissionCus.rejected;
    }
    return LocationPermissionCus.rejected;
  }

  Future<StreamSubscription<Position>?> listenStreamGeoLocation({
    required Function(Map<String, dynamic>?) onLocationUpdate,
  }) async {
    final LocationPermissionCus status = await _requestPermission();
    try {
      UtilFunctions.appLog("LocationPermissionCus $status");
      if (status == LocationPermissionCus.success) {
        UtilFunctions.appLog("Geolocator success");

        return Geolocator.getPositionStream(
          locationSettings: Platform.isAndroid
              ? AndroidSettings(
                  // intervalDuration: Duration(seconds: 60),
                  distanceFilter: _minDistanceToUpdate,
                  foregroundNotificationConfig:
                      const ForegroundNotificationConfig(
                        notificationTitle: "Location Fetching in background",
                        notificationText: "notificationText",
                        enableWakeLock: true,
                      ),
                )
              : AppleSettings(
                  accuracy: LocationAccuracy.high,
                  activityType: ActivityType.fitness,
                  distanceFilter: _minDistanceToUpdate,
                  pauseLocationUpdatesAutomatically: true,
                  showBackgroundLocationIndicator: false,
                ),
        ).listen((position) async {
          // UtilFunctions.appLog("getPositionStream $position");

          // ✅ Step 4: Get the user's current location
          final locationData = await _getUserLocation(position);
          if (locationData != null) {
            userLocation =
                'Latitude: ${locationData['latitude']}, Longitude: ${locationData['longitude']}\n'
                'City: ${locationData['city']}, Country: ${locationData['country']}\n'
                'Address: ${locationData['address']}, \n isMocked = ${locationData['isMocked']}';
          } else {
            userLocation = "Location unavailable";
          }
          notifyListeners();
          onLocationUpdate(locationData);
        });
      }
    } catch (e) {
      _handleLocationError(e);
    }

    return null;
  }

  static void _handleLocationError(dynamic error) {
    if (error is Exception) {
      String errorMessage = error.toString();

      if (errorMessage.contains('location service on the device is disabled')) {
        UtilFunctions.appLog('Location Error: Location services are disabled');
        // Log to your error tracking service
        UtilFunctions.appLog('Location services disabled $error');
        // Show user dialog to enable location
      } else if (errorMessage.contains('permission')) {
        UtilFunctions.appLog('Location Error: Permission denied');
        UtilFunctions.appLog('Location permission denied $error');
      } else {
        UtilFunctions.appLog('Location Error: Unknown error - $errorMessage');
        UtilFunctions.appLog('Unknown location error $error');
      }
    }
  }
}
