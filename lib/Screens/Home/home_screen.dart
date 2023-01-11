import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:login_signup/Screens/welcome_screen.dart';

User? loggedinUser;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;

  void initState() {
    super.initState();
    getCurrentUser();
  }

  //using this function you can use the credentials of the user
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: HexColor('#f85f6a') ,
        leading: null,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: IconButton(
                alignment: Alignment.topLeft,
               icon: Icon(Icons.close,
                  color: HexColor('#f85f6a')
               ),
                  onPressed: () => {Navigator.of(context).pop()},
              ),
            ),
            ListTile(
              leading: Icon(Icons.home,
                  color: HexColor('#f85f6a')),
              title: Text('Home'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(Icons.person,
                  color: HexColor('#f85f6a')),
              title: Text('Profile'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(Icons.shopping_basket,
                  color: HexColor('#f85f6a')),
              title: Text('Task'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(Icons.favorite_outlined,
                  color: HexColor('#f85f6a')),
              title: Text('Feedback'),
              onTap: () => {Navigator.pushNamed(context, 'feedback_screen')},
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app,
                  color: HexColor('#f85f6a')),
              title: Text('Logout'),
              onTap: () => {
                _auth.signOut(),
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  WelcomeScreen()),
            ),
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          "Welcome User",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
