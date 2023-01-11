import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_signup/Components/responsive.dart';
import 'package:login_signup/Screens/welcome_image.dart';
import 'package:provider/provider.dart';
import '../Components/background.dart';
import 'Home/home_screen.dart';
import 'Login/login_signup_btn.dart';
class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({Key? key}) : super(key: key);
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user!= null) {
      return HomeScreen();
    } else {
      return Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const WelcomeImage(),
            Row(
              children: const [
                Spacer(),
                Expanded(
                  flex: 8,
                  child: LoginAndSignupBtn(),
                ),
                Spacer(),
              ],
            ),
          ],
        ),
      );
    }
  }
  Future<User?> getCurrentUser() async {
    try {
      final user = await _auth.currentUser;

        return user;
    } catch (e) {
      print(e);
    }
  }
}

