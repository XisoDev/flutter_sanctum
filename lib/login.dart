import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanctum/auth.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;
  String _errorMessage = '';

  Future<void> submitForm() async {
    setState(() {
      _errorMessage = '';
    });
    bool result = await Provider.of<AuthProvider>(context, listen: false).login(_email, _password);
    if (result == false) {
      setState(() {
        _errorMessage = 'There was a problem with your credentials.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: ListView(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                  hintText: 'Email',
                  icon: Icon(
                    Icons.mail,
                  )
              ),
              validator: (value) => value != null ? 'Please enter an email address' : null,
              onSaved: (value) => _email = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Password',
                icon: Icon(
                  Icons.lock,
                ),
              ),
              obscureText: true,
              validator: (value) => value != null ? 'Please enter a password' : null,
              onSaved: (value) => _password = value!,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
              child: Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
              child: ElevatedButton(
                child: Text('Login'),
                onPressed: () {
                  _formKey.currentState?.save();
                  submitForm();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}