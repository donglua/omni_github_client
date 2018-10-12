import 'package:flutter/material.dart';
import 'package:omni_github_client/auth/auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  final AuthManager _authManager = AuthManager();

  @override
  State<StatefulWidget> createState() {
    return new _LoginScreenState(_authManager);
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthManager _authManager;

  final _usernameController = new TextEditingController();
  final _passwordController = new TextEditingController();

  void _handleSubmit() async {
    var _username = _usernameController.text;
    var _password = _passwordController.text;

    var loginResult = await _authManager.login(_username, _password);

    Fluttertoast.showToast(
        msg: loginResult.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        bgcolor: "#448AFF",
        textcolor: '#ffffff');

    if (loginResult.success) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  _LoginScreenState(this._authManager);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Login"),
        ),
        body: new Material(
          child: new Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: new TextField(
                  key: new Key('username'),
                  decoration: new InputDecoration.collapsed(
                      hintText: "Username or email"),
                  autofocus: true,
                  controller: _usernameController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: new TextField(
                  decoration:
                      new InputDecoration.collapsed(hintText: 'Password'),
                  controller: _passwordController,
                  obscureText: true,
                ),
              ),
              new RaisedButton(
                  child: new Text('Login'), onPressed: _handleSubmit)
            ],
          ),
        ));
  }
}
