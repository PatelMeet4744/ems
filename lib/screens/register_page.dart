import 'dart:async';

import 'package:ems/const/custom_styles.dart';
import 'package:ems/screens/Dashbord.dart';
import 'package:ems/screens/screen.dart';
import 'package:flutter/material.dart';
import '../widgets/widget.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import '../constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';

const List<String> list = <String>[
  'Surat',
  'Bardoli',
  'Ahmadabad',
  'Navsari',
  'Vapi'
];

const List<String> delist = <String>[
  'Project Manager',
  'Assistant Manager',
  'Sr. Developer',
  'Jr. Developer'
];

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController EmpId = TextEditingController();
  TextEditingController Empname = TextEditingController();
  TextEditingController Empemail = TextEditingController();
  TextEditingController Emppass = TextEditingController();
  TextEditingController Empcontact = TextEditingController();
  TextEditingController EmpDesignatiob = TextEditingController();
  TextEditingController Empsalary = TextEditingController();

  var gender = null;
  var hobby = false;
  var city = ["Surat", "Ahmedabad", "Bardoli", "Navsari"];

  String? email, Pass;

  String dropdownValue = list.first;
  String designationvalue = delist.first;

  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var selectedDate;

  @override
  Widget build(BuildContext context) {
    final CollectionReference _tblEmployee =
        FirebaseFirestore.instance.collection('employee');

    Future<void> _Add() async {
      print("Hello");
      String id = EmpId.text;
      String name = Empname.text;
      String contact = Empcontact.text;
      String Gender = gender.toString();
      String email = Empemail.text;
      String password = Emppass.text;
      String Designation = EmpDesignatiob.text;
      String salary = Empsalary.text;
      String city = dropdownValue.toString();
      String designation = designationvalue.toString();
      bool status = false;
      print("By");
      // String startDate = StartDateController.text;
      // final double? price = double.tryParse(StartDateController.text.toString());
      // String city = empc
      // String BOD =

      await _tblEmployee.add({
        "Eno": id,
        "Ename": name,
        "Econtactno": contact,
        "Egender": Gender,
        "Eemail": email,
        "Epassword": password,
        "Ecity": city,
        "Edesignation": designation,
        "Esalary": salary,
        "Estatus": status
      });
      //await _tblProduct.doc(documentSnapshot.id).
      //update({"name":name,"price":price});
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Registeration Page"),
        backgroundColor: kBackgroundColor,
        //backgroundColor: Colors.lightGreenAccent,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: [
                CircleAvatar(
                  maxRadius: 100,
                  backgroundColor: Colors.black,
                  child: Icon(
                    Icons.note_alt_outlined,
                    size: 150,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: EmpId,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.add),
                      label: Text("Enter Employee Number"),
                      hintText: "Enter Employee Number",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                SizedBox(
                  height: 25,
                ),
                TextField(
                  controller: Empname,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.account_circle),
                      label: Text("Enter Name"),
                      hintText: "Enter Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                SizedBox(
                  height: 25,
                ),
                TextField(
                  controller: Empcontact,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      label: Text("Enter Contact No."),
                      hintText: "Enter Contact No.",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: Colors.lightGreenAccent))),
                ),
                SizedBox(
                  height: 25,
                ),
                RadioListTile(
                    title: Text("Male"),
                    value: 'Male',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value;
                      });
                    }),
                RadioListTile(
                    title: Text("Female"),
                    value: 'Female',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value;
                      });
                    }),
                SizedBox(
                  height: 25,
                ),
                TextField(
                  controller: Empemail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      label: Text("Enter Email"),
                      hintText: "Enter Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                SizedBox(
                  height: 25,
                ),
                TextField(
                  obscureText: true,
                  controller: Emppass,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.remove_red_eye_sharp),
                      label: Text("Enter Password"),
                      hintText: "Enter Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  width: double.infinity,
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.black,
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                        print(value);
                      });
                    },
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  width: double.infinity,
                  child: DropdownButton<String>(
                    value: designationvalue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.black,
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        designationvalue = value!;
                        print(value);
                      });
                    },
                    items: delist.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.date_range),
                      hintText: 'Input Date of birth',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2100));
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                // TextField(
                //   controller: EmpDesignatiob,
                //   // // style: kBodyText.copyWith(color: Colors.white),
                //   // style: kBodyText.copyWith(color: Colors.white),
                //   decoration: InputDecoration(
                //       prefixIcon: Icon(Icons.accessibility),
                //       labelText: "Enter Designation",
                //       hintText: "Enter Designation",
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(20),
                //       )),
                // ),
                // SizedBox(
                //   height: 25,
                // ),
                TextField(
                  controller: Empsalary,
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.account_balance_wallet),
                      labelText: "Salary Offered",
                      hintText: "Salary Offered",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Alerdy have an account? ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => Registration(),
                          ),
                        );
                      },
                      child: Text(
                        'Sing In',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ).copyWith(
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                MyTextButton(
                  buttonName: 'Register',
                  onTap: () {
                    _Add();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignInPage()));
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                    );
                  },
                  bgColor: Colors.black,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
