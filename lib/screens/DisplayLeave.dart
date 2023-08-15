import 'package:ems/screens/AdminDashbord.dart';
import 'package:flutter/material.dart';
import 'package:ems/constants.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DisplayLeave extends StatefulWidget {
  // const DisplayLeave({super.key});
  var name;
  DisplayLeave(this.name);
  @override
  State<DisplayLeave> createState() => _DisplayLeaveState();
}

class _DisplayLeaveState extends State<DisplayLeave> {
  bool activeDeactive = false;
  final CollectionReference _tblEmployee =
      FirebaseFirestore.instance.collection('employee');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('${widget.name}');
  }

  Future<void> _Update(DocumentSnapshot documentSnapshot) async {
    await _tblEmployee
        .doc('${widget.name}')
        .collection("Leave")
        .doc(documentSnapshot.id)
        .update({'Status': !activeDeactive});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context,
                MaterialPageRoute(builder: (context) => AdminDashbord()));
          },
          icon: Image(
            width: 24,
            color: Colors.white,
            image: Svg('images/back_arrow.svg'),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: _tblEmployee
            .doc('${widget.name}')
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
                      subtitle: Text(documentSnapshot.id),
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
