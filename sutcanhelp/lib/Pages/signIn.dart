import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sutcanhelp/Pages/home.dart';
import 'package:flutter/material.dart';
import 'package:sutcanhelp/Pages/register.dart';
import 'package:sutcanhelp/widget/loading.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;
  bool loading = false;

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
      decoration: InputDecoration(
        hintText: "Email",
        hintStyle: TextStyle(
          color: Colors.black54,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        hoverColor: Colors.amber,
        fillColor: Colors.amber,
        prefixIcon: Icon(Icons.email),
      ),
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
      decoration: InputDecoration(
          hintText: "Password",
          hintStyle: TextStyle(
            color: Colors.black54,
            fontSize: 16.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
            onPressed: () {},
            icon: Icon(Icons.visibility_off),
          )),
      onSaved: (input) => _password = input,
      obscureText: true,
    );
  }

  Widget singInButton() {
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      shadowColor: Colors.black54,
      elevation: 5.0,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        height: 56.0,
        onPressed: signIn,
        child: Text(
          'Login',
          style: TextStyle(
            color: Colors.lightBlue,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      color: Colors.white,
    );
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
            ..color = Colors.grey[700],
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
        setState(() {
          loading = true;
        });
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => Home());
        Navigator.of(context).pushAndRemoveUntil(
            materialPageRoute, (Route<dynamic> route) => false);
      } catch (e) {
        print(e.message);
        signInAlert(e);
        setState(() {
          loading = false;
        });
      }
    }
  }

  void signInAlert(e) {
    Alert(context: context, title: 'Invalid Username or Password', buttons: [
      DialogButton(
        child: Text(
          'OK',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      )
    ]).show();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.lightBlueAccent,
            body: Container(
              margin: MediaQuery.of(context).padding,
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                            padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
                            child: Column(
                              children: <Widget>[
                                emailText(),
                                SizedBox(
                                  height: 20.0,
                                ),
                                passTesxt(),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: singInButton(),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
