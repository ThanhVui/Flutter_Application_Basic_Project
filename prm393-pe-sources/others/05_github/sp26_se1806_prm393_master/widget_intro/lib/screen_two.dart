import 'package:flutter/material.dart';

class ScreenTwo extends StatefulWidget {
  const ScreenTwo({super.key});

  @override
  State<ScreenTwo> createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text('Login', style: TextStyle(fontSize: 30),),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      print('Vui lòng nhập Email');
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      print('Vui lòng nhập Email');
                    }
                    return null;
                  },
                  obscureText: true,
                ),
                ElevatedButton(onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Lay username + password, xu ly dang nhap
                    // Route di vao screen ke tiep
                  } else {
                    // SnackBar
                    print('Form invalid');
                  }
                }, child: Text('Login'))
              ],
            ),
          )
          // Tìm hiểu widget Form (validation)
          // Form có 2 TextFormField (Username, Password)
          // 1 ElevatedButton -> click print theo format 'User: $u Pass: $p'

        ],
      ),
    );
  }
}