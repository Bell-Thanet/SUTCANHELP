import 'package:firebase_auth/firebase_auth.dart';
import 'package:sutcanhelp/Pages/home.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // appBar: new AppBar(
      //   backgroundColor: Colors.lightBlueAccent,
      //   title: Text("login"),
      // ),
      backgroundColor: Colors.lightBlueAccent,

      body: Container(
        margin: MediaQuery.of(context).padding, //เว้นระยะขอบบนของโทรศัพย์
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text("SUT",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 70,
                        foreground: Paint()
                          ..style = PaintingStyle.fill
                          ..strokeWidth = 5
                          ..color = Colors.white,
                      )),
                ),
                Container(
                  child: Text("CAN",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 70,
                        foreground: Paint()
                          ..style = PaintingStyle.fill
                          ..strokeWidth = 5
                          ..color = Colors.white,
                      )),
                ),
                Container(
                  child: Text("HELP",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 70,
                        foreground: Paint()
                          ..style = PaintingStyle.fill
                          ..strokeWidth = 5
                          ..color = Colors.white,
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 250,
                      child: Text("FOR PUBLIC",
                          // textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 25,
                            foreground: Paint()
                              ..style = PaintingStyle.fill
                              ..strokeWidth = 10
                              ..color = Colors.white,
                          )),
                    ),
                  ],
                ),
                Container(
                  width: 270,
                  child: TextFormField(
                    validator: (String input) {
                      if (input.isEmpty) {
                        return 'Provide an email';
                      }
                    },
                    decoration: InputDecoration(labelText: 'USERNAME'),
                    onSaved: (input) => _email = input,
                  ),
                ),
                Container(
                  width: 270,
                  child: TextFormField(
                    validator: (input) {
                      if (input.length < 6) {
                        return 'Longer password please';
                      }
                    },
                    decoration: InputDecoration(labelText: 'PASSWORD'),
                    onSaved: (input) => _password = input,
                    obscureText: true,
                  ),
                ),
                Padding(
                  //กำหนดระยะห่างระหว่างทุกข้าง
                  padding:
                      const EdgeInsets.fromLTRB(0, 20.0, 0, 0), //ระยะห่างข้างๆ
                  child: Container(
                    child: RaisedButton(
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
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }

  void signIn() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        AuthResult result = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        FirebaseUser user = result.user;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home(user: user)));
      } catch (e) {
        print(e.message);
      }
    }
  }
}
