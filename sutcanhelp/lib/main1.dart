/*import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() {
  runApp(MaterialApp(
    home: MainActivity(),
  ));
}


class MainActivity extends StatefulWidget {
  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {

  final DatabaseReference database = FirebaseDatabase.instance.reference().child("test");
 

  sendData() {
    database.push().set({
      'name' : 'ghj',
      'lastName' : 'b'
    });
  }
  String _email,_password;
  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        title: Text("Firebase"),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: (input){
                if(input.isEmpty){
                  return 'Please type an email';
                }
              },
              onSaved: (input) => _email = input,
              decoration: InputDecoration(
                labelText: 'Email'
              ),
            ),

            TextFormField(
              validator: (input){
                if(input.length < 6){
                  return 'please 6 char';
                }
              },
              onSaved: (input) => _password = input,
              decoration: InputDecoration(
                labelText: 'Password'
              ),
              obscureText: true,
            ),
            FlatButton(
                onPressed: () => sendData(),
                child: Text("Send"),
            color: Colors.amber),
          ],
        ),
      ),
    );
    return scaffold;
  }
}
*/
