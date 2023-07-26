import 'dart:async';
import 'package:flutter/material.dart';
import 'package:login_application/bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';


class SplashScreenPage extends StatefulWidget {
  @override
  SplashScreenPageState createState() => SplashScreenPageState();
}

class SplashScreenPageState extends State<SplashScreenPage> {

  static const String KEYLOGIN = "login";

  @override
  void initState() {
    super.initState();
    // Start the timer when the widget is created
    whereToGo();

  }

  // Function to navigate to the next page after the timer is finished
   navigateToNextPage(var loggedIn) {

    if(loggedIn!=null){
      if(loggedIn==true){
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => BottomNavigation(), // Replace 'NextPage' with your desired page
          ),
        );
      } else{
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Login(), // Replace 'NextPage' with your desired page
          ),
        );
      }
    } else{
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Login(), // Replace 'NextPage' with your desired page
        ),
      );
    }


  }

  // Function to start the timer


  @override
  Widget build(BuildContext context) {
    // Customize your splash screen UI here
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Public Traffic",style: TextStyle(fontWeight: FontWeight.w600,color:Colors.black),),
              SizedBox(height: 50,),
              Icon(Icons.traffic_outlined)
            ],
          ),
        ),
      ),
    );
  }

  void whereToGo() async {

    var sharedPref = await SharedPreferences.getInstance();
    var loggedIn = sharedPref.getBool(KEYLOGIN);
    Timer(Duration(seconds: 20), navigateToNextPage(loggedIn)); // Replace '3' with your desired duration in seconds

  }
}

