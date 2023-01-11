import 'package:firebase_auth/firebase_auth.dart';
import '../../constants.dart';
import 'package:flutter/material.dart';

import 'login_screen_top_image.dart';

//code for designing the UI of our text field where the user writes his email id or password


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

final _auth = FirebaseAuth.instance;

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
               LoginScreenTopImage(),
          Row(
            children: [
              Spacer(),
              Expanded(
                flex: 20,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              SizedBox(
              width: 380,
              child:  Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                    //Do something with the user input.
                  },
              decoration: const InputDecoration(
                hintText: "Your Email",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
              ),
              SizedBox(
                height: 15.0,
              ),
              TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: "Your Password",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Icon(Icons.lock),
                    ),
                  ),
                  onChanged: (value) {
                    password = value;
                    //Do something with the user input.
                  }),
                SizedBox(
                height: 24.0,
              ),
              Hero(
                tag: 'login_btn',
                child:ElevatedButton(
                    child: Text(
                      "Login".toUpperCase(),
                    ),
                  onPressed: () async {
                    buildShowDialog(context);
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (user != null) {
                        Navigator.pushNamed(context, 'home_screen');
                      }
                    } catch (e) {
                      print(e);
                    }

                  }),
              ),
            ],
          ),
        ),
      ),

              ],
          ),
        ),
          ],
        ),
      ]),
    ),
    );
  }
  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
