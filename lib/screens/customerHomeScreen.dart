import 'package:bookings/screens/bookingScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerHomeScreen extends StatefulWidget {
  CustomerHomeScreen({var user});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<CustomerHomeScreen> {
  Future getList() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    QuerySnapshot snapshot =
        await users.where('type', isEqualTo: 'Executive').get();
    print(snapshot.docs);
    return snapshot.docs;
  }

  @override
  void initState() {
    getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(snapshot.data[0].data.get('name'));
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
          future: getList(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: Text('Loading...'));
            return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: (snapshot.hasData) ? snapshot.data.length : 1,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('${FlutterLogo(size: 5)}'),
                      ),
                    
                      title: Text('${snapshot.data[index].get('name')}'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookingPage(
                                    executiveId:
                                        '${snapshot.data[index].get('id')}',
                                  )),
                        );
                      },
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
