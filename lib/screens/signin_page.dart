import 'dart:html';
import 'dart:js_interop';

import 'package:ems/main.dart';
import 'package:ems/screens/AdminDashbord.dart';
import 'package:ems/screens/Dashbord.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../screens/screen.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import '../widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickalert/quickalert.dart';

var loggedin;
var Adminloggedin;
const List<String> rolelist = <String>[
  'Admin',
  'Employee',
];

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isPasswordVisible = true;
  String Role = rolelist.first;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ScreenNavigation();
  }

  void ScreenNavigation() async {
    var pref = await SharedPreferences.getInstance();
    loggedin = pref.getBool("isloggedin");
    Adminloggedin = pref.getBool("isAdminloggedin");
    print(loggedin);
    if (loggedin != null) {
      if (loggedin) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Dashbord()));
      }
    }
    if (Adminloggedin != null) {
      if (Adminloggedin) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AdminDashbord()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference _tblEmployee =
        FirebaseFirestore.instance.collection('employee');

    Future<void> _singin() async {
      if (Role == 'Admin') {
        if (_email.text == "Admin@gmail.com" && _password.text == "Admin123") {
          var pref = await SharedPreferences.getInstance();
          pref.setBool("isAdminloggedin", true);
          pref.setString("Name", "Admin");
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AdminDashbord()));
        }
      } else {
        try {
          QuerySnapshot querySnapshot = await _tblEmployee
              .where("Eemail", isEqualTo: _email.text)
              .where("Epassword", isEqualTo: _password.text)
              .get();
          if (querySnapshot.docs.length == 0) {
            QuickAlert.show(
              context: context,
              text: "No User is found",
              type: QuickAlertType.error,
            );
          }
          // Process the querySnapshot
          for (QueryDocumentSnapshot doc in querySnapshot.docs) {
            // bool status = doc['Estatus'];
            if (doc['Estatus'] == true) {
              var pref = await SharedPreferences.getInstance();
              pref.setBool("isloggedin", true);
              pref.setString("Id", doc.id);
              pref.setString("Name", doc['Ename']);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Dashbord()));
            } else {
              QuickAlert.show(
                context: context,
                text: "You are not activated",
                type: QuickAlertType.error,
              );
              print("Status False");
            }
            print(
                'Name: ${doc['Ename']}, Status: ${doc['Estatus']},Id: ${doc.id}');
          }
        } catch (e) {
          print('Error fetching data: $e');
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
          );
        }
      }

      // StreamBuilder(
      //   stream: _tblEmployee
      //       .where("Eemail", isEqualTo: _email.text)
      //       .where("Epassword", isEqualTo: _password.text)
      //       .snapshots(), //contains data
      //   builder: (context, AsyncSnapshot<QuerySnapshot> streamsnapshot) {
      //     if (streamsnapshot.hasData) {
      //       print(streamsnapshot.data!.docs[0]);
      //     }
      //     return const Center(
      //       child: CircularProgressIndicator(),
      //     );
      //   },
      // );

      // var result = await _tblEmployee
      //     .where(
      //       "Eemail",
      //       isEqualTo: _email.text,
      //     )
      //     .where("Epassword", isEqualTo: _password.text)
      //     .get();

      // print(result.docs.length);

      // print(result);

      // var result = await _tblEmployee
      //     .where("Eemail", isEqualTo: 'rahul123@gmail.com')
      //     .get();
      // print( result.docs.length);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
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
      body: SafeArea(
        //to make page scrollable
        child: CustomScrollView(
          reverse: true,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome back.",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "You've been missed!",
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: 60,
                          ),
                          MyTextField(
                            textEditingController: _email,
                            hintText: 'Email',
                            inputType: TextInputType.emailAddress,
                          ),
                          MyPasswordField(
                            hintText: 'Password',
                            textEditingController: _password,
                            isPasswordVisible: isPasswordVisible,
                            onTap: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                          Container(
                            width: double.infinity,
                            child: DropdownButton<String>(
                              value: Role,
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
                                  Role = value!;
                                  print(value);
                                });
                              },
                              items: rolelist.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Dont't have an account? ",
                          style: kBodyText,
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
                            'Register',
                            style: kBodyText.copyWith(
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MyTextButton(
                      buttonName: 'Sign In',
                      onTap: () {
                        _singin();
                      },
                      bgColor: Colors.black,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
