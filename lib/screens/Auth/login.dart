// create login screen that has emali and password fields
import 'package:countrysidecart/screens/Auth/signup_screen.dart';
import 'package:countrysidecart/screens/home.dart';
import 'package:flutter/material.dart';

import '../../database/auth.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordontroller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              obscureText: true,
              controller: _passwordontroller,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await signInWithEmailAndPassword(
                  _emailController.text,
                  _passwordontroller.text,
                ).then((val) {
                  if (val) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  }
                });
              },
              child: Text('Login'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpScreen(),
                      ));
                },
                child: Text('signup'))
          ],
        ),
      ),
    );
  }
}
