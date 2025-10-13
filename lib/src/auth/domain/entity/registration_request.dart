class RegistrationRequest {
  String firstName;
  String lastName;
  String username;
  String email;
  String phone;
  String password;
  String passwordConfirmation;

  RegistrationRequest({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "username": username,
    "email": email,
    "phone": phone,
    "password": password,
    "password_confirmation": passwordConfirmation,
  };
}
