import 'package:bookings/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingPage extends StatefulWidget {
  final String executiveId;
  BookingPage({@required this.executiveId});
  @override
  _BookingPageState createState() => _BookingPageState();
}


class _BookingPageState extends State<BookingPage> {
String currentUserUid;
DocumentReference currentUserDoc;
var requestsPath;
 String request;

  
  Future<void> getUserData(){
    FirebaseAuth _auth = FirebaseAuth.instance;
    currentUserUid = (_auth.currentUser).uid;
    String uid = currentUserUid;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    currentUserDoc=firestore.collection('users').doc(uid);
    requestsPath = firestore.collection('requests');
  }
  
  
  Future<void> submitRequest() {
    return requestsPath
        .doc()
        .set({
          'request':request,
          'senderName':currentUserDoc,
          'recieverId':widget.executiveId
          
        })
        .then((value) => print("requested"))
        .catchError((error) => print("Failed to add request: $error"));
  }

  @override
  void initState() { 
    super.initState();
    getUserData();
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(
              child: Container(padding: EdgeInsets.all(10),child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [Ktextfield(
                onChanged: (value) {
                  request=value;
                },hintText: 'Enter your wish here!',
                
              ),
              SizedBox(
                height: 8.0,
              ),Kbutton(child: Text('Confirm Booking'), onPressed: (){submitRequest();})],),
          ),
      ),
      );
  }
}