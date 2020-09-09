import 'package:bookings/screens/customerHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bookings/constants/constants.dart';

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  String name;
  String selectedType;
  CollectionReference users;
  String currentUser;

  void getUserData() {
    FirebaseAuth _auth = FirebaseAuth.instance;
    currentUser = (_auth.currentUser).uid;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    users = firestore.collection('users');
  }

  Future<void> addUser() {
    return users
        .doc(currentUser)
        .set({
          'name': name, // John Doe
          'type': selectedType,
          // 'id':currentUser // Stokes and Sons
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  void initState() {
    super.initState();
    // Firebase.initializeApp();
    getUserData();
  }

  List<String> types = ['Select type', 'Executive', 'Customer'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Ktextfield(hintText: 'Enter your full name',
            onChanged: (value) {
              name = value;
            },
          ),
          DropdownButton(
              hint: Text(types[0]),
              items: types.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedType = value;
                });
              }),
          Kbutton(
            onPressed: () {
              addUser();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerHomeScreen(),
                ),
              );
            },
            child: Text(
              "Register",
            ),
          )
        ]),
      ),
    );
  }
}
