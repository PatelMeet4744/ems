import 'package:ems/screens/DisplayLeave.dart';
import 'package:ems/screens/screen.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var name;

class AdminDashbord extends StatefulWidget {
  const AdminDashbord({super.key});

  @override
  State<AdminDashbord> createState() => _AdminDashbordState();
}

class _AdminDashbordState extends State<AdminDashbord> {
  bool activeDeactive = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getvaluefrompref();
  }

  void getvaluefrompref() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      name = pref.getString("Name");
      print(name);
    });
  }

  final CollectionReference _tblEmployee =
      FirebaseFirestore.instance.collection('employee');

  void Logout() async {
    var pref = await SharedPreferences.getInstance();
    pref.setBool("isAdminloggedin", false);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => WelcomePage()));
  }

  Future<void> _Update(DocumentSnapshot documentSnapshot) async {
    print(documentSnapshot.id);
    print(activeDeactive);
    await _tblEmployee
        .doc(documentSnapshot.id)
        .update({'Estatus': !activeDeactive});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        title: Text(
          name.toString(),
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Logout();
            },
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image(
            width: 24,
            color: Colors.white,
            image: Svg('images/back_arrow.svg'),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: _tblEmployee.snapshots(), //contains data

        builder: (context, AsyncSnapshot<QuerySnapshot> streamsnapshot) {
          if (streamsnapshot.hasData) {
            // var userid = id;
            // print("Hello using id" + "'${id}'");
            print(streamsnapshot.data!.docs.length);
            return ListView.builder(
              itemCount:
                  streamsnapshot.data!.docs.length, //docs refers to the rows
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamsnapshot.data!.docs[index];
                activeDeactive = documentSnapshot['Estatus'];
                return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DisplayLeave(documentSnapshot.id)));
                      },
                      title: Text(documentSnapshot['Ename']),
                      subtitle: Text(documentSnapshot['Eemail']),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: activeDeactive
                                        ? Colors.green
                                        : Colors.red),
                                onPressed: () async {
                                  _Update(documentSnapshot);
                                },
                                child: activeDeactive
                                    ? Text(
                                        "Active",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      )
                                    : Text(
                                        "Deactive",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      )),
                            // IconButton(
                            //     onPressed: () {
                            //       // _showForm(documentSnapshot);
                            //     },
                            //     icon: Icon(Icons.edit)),
                            // IconButton(
                            //     onPressed: () {
                            //       // _Delete(documentSnapshot.id);
                            //     },
                            //     icon: Icon(Icons.delete))
                          ],
                        ),
                      ),
                    ));
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
