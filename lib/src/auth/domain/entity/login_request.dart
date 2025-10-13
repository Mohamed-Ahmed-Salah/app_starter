
class LoginRequest {
  String identifier;
  String password;
  String deviceIdentifier;

  LoginRequest({
    required this.identifier,
    required this.password,
    required this.deviceIdentifier,
  });

  Map<String, dynamic> toJson() => {
    "identifier": identifier,
    "password": password,
    "device_identifier": deviceIdentifier,
  };
}
