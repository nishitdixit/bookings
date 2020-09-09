import 'package:bookings/constants/constants.dart';
import 'package:bookings/services/authService.dart';
import 'package:flutter/material.dart';


class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  String mobileNo;
  String otp;
  AuthService auth;

  @override
  void initState() {
    auth = AuthService();
    auth.initializeFirebase();
    // Firebase.initializeApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Ktextfield(
                onChanged: (value) {
                  mobileNo = value.trim();
                },
                hintText: 'Enter your Mobile number',
              ),
              SizedBox(
                height: 8.0,
              ),
              Kbutton(
                child: Text(
                  'Log In',
                ),
                onPressed: () {
                  auth.verifyphone(
                      mobileNo: mobileNo, context: context, otp: otp);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
