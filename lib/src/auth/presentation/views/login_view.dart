import 'package:flutter/material.dart';

/// Placeholder. [AuthEventHandlerService] sends the user here on a 401, so the
/// route must exist before auth is built out.
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  static const String path = '/login';
  static const String name = 'login';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Login')));
  }
}
