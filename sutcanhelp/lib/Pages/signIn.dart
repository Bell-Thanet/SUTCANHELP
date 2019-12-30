import 'package:firebase_auth/firebase_auth.dart';
import 'package:sutcanhelp/Pages/home.dart';
import 'package:flutter/material.dart';
import 'package:sutcanhelp/Pages/register.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;

  Widget sutText() {
    return Text("SUT",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 70,
          foreground: Paint()
            ..style = PaintingStyle.fill
            ..strokeWidth = 5
            ..color = Colors.white,
        ));
  }

  Widget canText() {
    return Text("CAN",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 70,
          foreground: Paint()
            ..style = PaintingStyle.fill
            ..strokeWidth = 5
            ..color = Colors.white,
        ));
  }

  Widget helpText() {
    return Text("HELP",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 70,
          foreground: Paint()
            ..style = PaintingStyle.fill
            ..strokeWidth = 5
            ..color = Colors.white,
        ));
  }

  Widget forpuText() {
    return Text("FOR PUBLIC",
        // textAlign: TextAlign.right,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 25,
          foreground: Paint()
            ..style = PaintingStyle.fill
            ..strokeWidth = 10
            ..color = Colors.white,
        ));
  }

  Widget emailText() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: (String input) {
        if (input.isEmpty) {
          return 'Provide an email';
        }
      },
      decoration: InputDecoration(labelText: 'EMAIL'),
      onSaved: (input) => _email = input,
    );
  }

  Widget passTesxt() {
    return TextFormField(
      validator: (input) {
        if (input.length < 6) {
          return 'Longer password please';
        }
      },
      decoration: InputDecoration(labelText: 'PASSWORD'),
      onSaved: (input) => _password = input,
      obscureText: true,
    );
  }

  Widget singInButton() {
    return RaisedButton(
        onPressed: signIn,
        child: Text('เข้าสู่ระบบ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 25,
              foreground: Paint()
                ..style = PaintingStyle.fill
                ..strokeWidth = 10
                ..color = Colors.lightBlueAccent,
            )),
        color: Colors.white);
  }

  Widget toRegister() {
    return FlatButton(
      child: Text(
        "ยังไม่เป็นสมาชิก",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 18,
          foreground: Paint()
            ..style = PaintingStyle.fill
            ..strokeWidth = 5
            ..color = Colors.white,
        ),
      ),
      onPressed: () {
        print("can register");
        MaterialPageRoute materialPageRoute = MaterialPageRoute(
            builder: (BuildContext context) => RegisterPage());
        Navigator.of(context).push(materialPageRoute);
      },
    );
  }

  Future<void> signIn() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        AuthResult result = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        FirebaseUser user = result.user;

        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => Home());
        Navigator.of(context).pushAndRemoveUntil(
            materialPageRoute, (Route<dynamic> route) => false);
      } catch (e) {
        print(e.message);
        signInAlert();
      }
    }
  }

  void signInAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Invalid Username or Password',
              style: TextStyle(color: Colors.red),
            ),
            actions: <Widget>[okButton()],
          );
        });
  }

  Widget okButton() {
    return FlatButton(
      child: Text('OK'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Container(
        margin: MediaQuery.of(context).padding,
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        sutText(),
                        canText(),
                        helpText(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 65, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              forpuText(),
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                      child: Column(
                        children: <Widget>[
                          emailText(),
                          passTesxt(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: singInButton(),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        toRegister(),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
