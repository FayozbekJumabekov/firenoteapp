import 'package:firebase_auth/firebase_auth.dart';
import 'package:firenoteapp/pages/sign_up_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../services/auth_services.dart';
import '../services/hive_service.dart';
import 'home_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);
  static const String id = "sign_in_page";

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool hidePassword = true;

  void _doSignIn(BuildContext context) {
    String email = _emailController.text.toString().trim();
    String password = _passwordController.text.toString().trim();
    AuthenticationService.signInUser(context,email, password).then((value) => {
      getUser(value),
    });
  }

  void getUser(User? user) async {
    if (user != null) {
      HiveService.saveUserId(user.uid);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage(user: user,)));

      print(HiveService.loadUserId('userId'));
    } else {
      if (kDebugMode) {
        print("Null response");
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.green.shade900,
                    Colors.green,
                    Colors.green.shade400,
                  ])),
          child: Column(
            children: [
              /// Login and Welcome text
              Container(
                height: 200,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    Text(
                      "Sign In",
                      style: TextStyle(color: Colors.white, fontSize: 35),
                    ),
                    Text(
                      "Welcome back",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
              /// Text field and buttons

              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50))),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),

                      /// TextFields
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 25),
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(
                                    0.4,
                                  ),
                                  offset: Offset(0, 10),
                                  blurRadius: 20,
                                  spreadRadius: 10)
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /// Email
                            TextField(
                              controller:  _emailController,
                              decoration: const InputDecoration(
                                  contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                                  hintText: "Email",
                                  hintStyle: TextStyle(
                                      fontSize: 15, color: Colors.grey),
                                  border: InputBorder.none),
                            ),
                            const Divider(
                              height: 10,
                              color: Colors.black26,
                              thickness: 0.5,
                            ),

                            /// password
                            TextField(
                              obscureText: hidePassword,
                              controller: _passwordController,
                              textAlignVertical: TextAlignVertical.center,
                              decoration:  InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                  hintText: "Password",
                                  suffixIcon: IconButton(onPressed: (){
                                    setState(() {
                                      hidePassword = !hidePassword;
                                    });
                                  },iconSize: 22,
                                    icon: Icon((hidePassword) ? Icons.visibility_off:Icons.visibility),color: Colors.grey,),
                                  hintStyle: TextStyle(
                                      fontSize: 15, color: Colors.grey),
                                  border: InputBorder.none),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      // Login Button
                      Builder(
                        builder: (context) {
                          return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green.shade600,
                                fixedSize: const Size(200, 45),
                                shape: const StadiumBorder(),
                              ),
                              onPressed: () {
                                _doSignIn(context);
                                FocusScope.of(context).requestFocus(FocusNode());

                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ));
                        }
                      ),

                      const SizedBox(
                        height: 25,
                      ),

                      ///text
                      RichText(
                          text: TextSpan(
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                              text: "Don't have an account? ",
                              children: [
                                TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushReplacementNamed(
                                            context, SignUpPage.id);
                                      },
                                    style: TextStyle(color: Colors.blue),
                                    text: "Sign up"),
                              ])),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
