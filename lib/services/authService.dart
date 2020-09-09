import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bookings/screens/registration.dart';
import 'package:bookings/screens/customerHomeScreen.dart';
import 'package:firebase_core/firebase_core.dart';


class AuthService{

  Future initializeFirebase()async{
  await Firebase.initializeApp();
  }
  void verifyphone({@required String mobileNo,@required BuildContext context,@required otp}) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
      phoneNumber: mobileNo,
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential credential) async {
        try {
          Navigator.of(context).pop();
          UserCredential user = await _auth.signInWithCredential(credential);
          User firebaseuser = user.user;
          if (user != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RegisterUser()));
          }
        } catch (e) {
          print(e);
        }
        
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, [int forceResendingToken]) {
        showDialog(
          context: context,
          barrierDismissible:
              false, // dialog is dismissible with a tap on the barrier
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Enter otp'),
              content: new Row(
                children: <Widget>[
                  new Expanded(
                      child: new TextField(
                    autofocus: true,
                    decoration: new InputDecoration(hintText: '*****'),
                    onChanged: (value) {
                      otp = value;
                    },
                  ))
                ],
              ),
              actions: <Widget>[
                RaisedButton(
                  child: Text('verify'),
                  onPressed: () async {
                    otp = otp.trim();
                    AuthCredential credential = PhoneAuthProvider.credential(
                        verificationId: verificationId, smsCode: otp);
                    UserCredential user =
                        await _auth.signInWithCredential(credential);
                    User firebaseuser = user.user;
                    print(firebaseuser);

                    if (user != null) {
                      // Navigator.of(otpcontext).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerHomeScreen(
                            user: firebaseuser,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out...
      },
    );
  }


  
}