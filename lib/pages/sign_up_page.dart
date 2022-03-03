import 'package:firebase_auth/firebase_auth.dart';
import 'package:firenoteapp/pages/home_page.dart';
import 'package:firenoteapp/pages/sign_in_page.dart';
import 'package:firenoteapp/services/auth_services.dart';
import 'package:firenoteapp/services/hive_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../services/log_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static const String id = "sign_up_page";

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  bool hidePassword = true;

  void _doSignUp(BuildContext context) {
    String email = _emailController.text.toString().trim();
    String password = _passwordController.text.toString().trim();
    String firstName = _firstNameController.text.toString().trim();
    String lastName = _lastNameController.text.toString().trim();

    AuthenticationService.signUpUser(
            context: context,
            name: "$firstName $lastName",
            email: email,
            password: password)
        .then((value) => {
              getUser(value),
            });
  }

  void getUser(User? firebaseuser) async {
    if (firebaseuser != null) {
      HiveService.saveUserId(firebaseuser.uid);
      (HiveService.loadUserId('userId').then((value) => {
        Log.w(value)
      }));
      Navigator.pushReplacementNamed(context, SignInPage.id);
    } else {
      if (kDebugMode) {
        print("No Data");
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.center,
                  colors: [
                Colors.grey.shade900,
                Colors.grey.shade800,
                Colors.grey.shade700,

                // Colors.black45
              ])),
          child: Column(
            children: [
              /// Sign Up and Welcome texts
              Expanded(
                flex: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 30, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 35, color: Colors.white),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Welcome",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),

              /// Text field and buttons
              Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.only(left: 25, right: 25),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(
                              40,
                            ),
                            topLeft: Radius.circular(40))),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),

                        /// TextFields
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(171, 171, 171, 0.7),
                                    blurRadius: 20,
                                    offset: Offset(0, 10)),
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /// Firstname
                              Container(
                                padding: EdgeInsets.all(8),
                                child: TextField(
                                  controller: _firstNameController,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 5),
                                    hintText: "First Name",
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        fontSize: 15, color: Colors.grey),
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 0,
                                color: Colors.black26,
                                thickness: 0.5,
                              ),
                              Container(
                                padding: EdgeInsets.all(8),
                                child: TextField(
                                  controller: _lastNameController,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 5),
                                    hintText: "Last Name",
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        fontSize: 15, color: Colors.grey),
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 0,
                                color: Colors.black26,
                                thickness: 0.5,
                              ),

                              /// Email
                              Container(
                                padding: EdgeInsets.all(8),
                                child: TextField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 5),
                                    hintText: "Email",
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        fontSize: 15, color: Colors.grey),
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 0,
                                color: Colors.black26,
                                thickness: 0.5,
                              ),

                              /// Password
                              Container(
                                padding: EdgeInsets.all(8),
                                child: TextField(
                                  obscureText: hidePassword,
                                  controller: _passwordController,
                                  textAlignVertical: TextAlignVertical.center,

                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 5),
                                    suffixIcon: IconButton(onPressed: (){
                                      setState(() {
                                        hidePassword = !hidePassword;
                                      });
                                    },iconSize: 22,
                                      icon: Icon((hidePassword) ? Icons.visibility_off:Icons.visibility),color: Colors.grey,),
                                    hintText: "Password",
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        fontSize: 15, color: Colors.grey),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),

                        ///Sign Up button
                        Builder(builder: (context) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                primary: Colors.black38,
                                fixedSize: Size(
                                    MediaQuery.of(context).size.width / 2, 45)),
                            onPressed: () {
                              _doSignUp(context);
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                            child: const Text(
                              "SignUp",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          );
                        }),
                        const SizedBox(
                          height: 20,
                        ),

                        ///text
                        RichText(
                            text: TextSpan(
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                                text: "Already have an account? ",
                                children: [
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushReplacementNamed(
                                          context, SignInPage.id);
                                    },
                                  style: TextStyle(color: Colors.blue),
                                  text: "Sign In"),
                            ])),

                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
