import 'package:flutter/material.dart';
import 'package:ems/const/custom_colors.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FocusNode _focusNodePassword = FocusNode();
  var phoneController = TextEditingController();
  var pswdController = TextEditingController();
  final TextEditingController _controllerUsername = TextEditingController();

  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {},
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgcolor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 150),
              Text(
                "Welcome back",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),
              Text(
                "Login to your account",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              // CircleAvatar(
              //   backgroundColor: Colors.green,
              //   maxRadius: 60,
              //   child: Icon(Icons.add_shopping_cart, size: 50),
              // ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                //  maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Enter UserName',
                  hintText: 'UserName',
                  //enabled: false,

                  prefixIcon: Icon(Icons.phone),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Colors.deepOrange, width: 2)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Colors.purpleAccent, width: 2)),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.green, width: 2)),
                ),
              ),
              Container(
                height: 20,
              ),
              TextField(
                controller: pswdController,
                obscureText: true,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                    labelText: 'Enter Password',
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.remove_red_eye),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.deepOrange, width: 2)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.purpleAccent, width: 2))),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    String phone = phoneController.text.toString();
                    String pswd = pswdController.text.toString();

                    if (phone == "1234567890" && pswd == "1234") {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    } else {
                      AlertDialog alert = AlertDialog(
                        title: Text("My title"),
                        content: Text("This is my message."),
                        actions: [
                          okButton,
                        ],
                      );
                      print("Wrong username and password");
                    }
                  },
                  child: const Text('Login'))
            ],
          ),
        ));
  }
}
