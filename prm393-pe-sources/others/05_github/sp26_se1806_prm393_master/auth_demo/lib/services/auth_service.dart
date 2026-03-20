import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  String loginWithEmail(String email, String password) {
    if (email == "VanA" && password == "Password@123") {
      return "Login Successful";
    }
    return "Login Error";
  }

  Future<void> login(String username, String password) async {
    // Gui http request den auth server
    // (API endpoint: POST https://dummyjson.com/auth/login)
    // Body: JSON username + password
    final response = await http.post(
      Uri.parse('https://dummyjson.com/auth/login'),
      body: jsonEncode({username: username, password: password}),
      headers: {'Content-Type': 'application/json'},
    );

    print(username);
    print(password);

    print('API called: status ${response.statusCode}');
    print('body: ${response.body}');
  }
}
