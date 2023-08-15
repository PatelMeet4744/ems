import 'dart:js_util';

import 'package:ems/screens/screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickalert/quickalert.dart';
import '../constants.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:intl/intl.dart';

var id;
var name;

class Dashbord extends StatefulWidget {
  const Dashbord({super.key});

  @override
  State<Dashbord> createState() => _DashbordState();
}

class _DashbordState extends State<Dashbord> {
  bool activeDeactive = false;
  var dateController = TextEditingController();
  var enddateController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Getvaluefrompref();
  }

  void Getvaluefrompref() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("Id");
      name = pref.getString("Name");
    });
    // print(id);
  }

  void Logout() async {
    var pref = await SharedPreferences.getInstance();
    pref.setBool("isloggedin", false);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => WelcomePage()));
  }

  final CollectionReference _tblEmployee =
      FirebaseFirestore.instance.collection('employee');

  final nameController = TextEditingController();
  // final StartDateController = TextEditingController();
  // final EndDateController = TextEditingController();

  Future<void> _Delete(String leaveId) async {
    await _tblEmployee.doc(id).collection("Leave").doc(leaveId).delete();
  }

  void _showForm(DocumentSnapshot? documentSnapshot) async {
    if (documentSnapshot != null) {
      nameController.text = documentSnapshot['Reason'];
      dateController.text = documentSnapshot['StartDate'];
      enddateController.text = documentSnapshot['endDate'];
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 5,
      builder: (context) => Container(
        padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Enter Leave Reason'),
            ),
            SizedBox(
              height: 10,
            ),
            // TextField(
            //   controller: StartDateController,
            //   decoration: InputDecoration(labelText: 'Start Date'),
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            // TextField(
            //   controller: EndDateController,
            //   decoration: InputDecoration(labelText: 'End Date'),
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            TextField(
                controller:
                    dateController, //editing controller of this TextField
                decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today), //icon of text field
                    labelText: "Start Date" //label text of field
                    ),
                readOnly: true, // when true user cannot edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), //get today's date
                      firstDate: DateTime(
                          2000), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101));
                  if (pickedDate != null) {
                    // print(pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                    String formattedDate = DateFormat('yyyy-MM-dd').format(
                        pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                    // print(formattedDate); //formatted date output using intl package =>  2022-07-04
                    //You can format date as per your need

                    setState(() {
                      dateController.text =
                          formattedDate; //set foratted date to TextField value.
                    });
                    print(dateController.text);
                  } else {
                    print("Date is not selected");
                  }
                  //when click we have to show the datepicker
                }),
            SizedBox(
              height: 10,
            ),
            TextField(
                controller:
                    enddateController, //editing controller of this TextField
                decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today), //icon of text field
                    labelText: "Start Date" //label text of field
                    ),
                readOnly: true, // when true user cannot edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), //get today's date
                      firstDate: DateTime(
                          2000), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101));
                  if (pickedDate != null) {
                    // print(pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                    String formattedDate = DateFormat('yyyy-MM-dd').format(
                        pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                    // print(formattedDate); //formatted date output using intl package =>  2022-07-04
                    //You can format date as per your need

                    setState(() {
                      enddateController.text =
                          formattedDate; //set foratted date to TextField value.
                    });
                    print(enddateController.text);
                  } else {
                    print("Date is not selected");
                  }
                  //when click we have to show the datepicker
                }),
            ElevatedButton(
                onPressed: () {
                  if (documentSnapshot == null)
                    _Add();
                  else
                    _Update(documentSnapshot);
                  nameController.clear();
                  dateController.clear();
                  enddateController.clear();
                  Navigator.of(context).pop();
                },
                child: Text(documentSnapshot == null ? 'Create New' : 'Update'))
          ],
        ),
      ),
    );
  }

  Future<void> _Add() async {
    String name = nameController.text;
    String startDate = dateController.text;
    String endDate = enddateController.text;
    // final double? price = double.tryParse(dateController.text.toString());

    await _tblEmployee.doc(id).collection('Leave').add({
      'Reason': name,
      'StartDate': startDate,
      'endDate': endDate,
      'Status': false
    });
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
    );
    //await _tblProduct.doc(documentSnapshot.id).
    //update({"name":name,"price":price});
  }

  Future<void> _Update(DocumentSnapshot documentSnapshot) async {
    String name = nameController.text;
    String startDate = dateController.text;
    String endDate = enddateController.text;

    await _tblEmployee
        .doc(id)
        .collection("Leave")
        .doc(documentSnapshot.id)
        .update({
      'Reason': name,
      'StartDate': startDate,
      'endDate': endDate,
      'Status': false
    });
  }

  //Future<void> _getsubcollection() async {
  // Future<void> _getsub() async {
  //   try {
  //     QuerySnapshot querySnapshot =
  //         await _tblEmployee.doc(id).collection("Leave").get();

  //     // Process the querySnapshot
  //     for (QueryDocumentSnapshot doc in querySnapshot.docs) {
  //       print('Name: ${doc['Reason']}');
  //     }
  //   } catch (e) {
  //     print('Error fetching data: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        //   title: Text('Dashbord'),
        // ),
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _showForm(null);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: StreamBuilder(
          stream: _tblEmployee
              .doc(id)
              .collection("Leave")
              .snapshots(), //contains data

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
                  activeDeactive = documentSnapshot['Status'];
                  return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(documentSnapshot['Reason']),
                        subtitle: activeDeactive
                            ? Text(
                                "Activate",
                                style: TextStyle(
                                    backgroundColor: Colors.green,
                                    color: Colors.white,
                                    fontSize: 15),
                              )
                            : Text(
                                'Deactivate',
                                style: TextStyle(
                                    backgroundColor: Colors.red,
                                    color: Colors.white,
                                    fontSize: 15),
                              ),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    _showForm(documentSnapshot);
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    _Delete(documentSnapshot.id);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.black,
                                  ))
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
        ));
  }
}
