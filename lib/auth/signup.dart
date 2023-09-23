import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase02/components/costomlogoauth.dart';
import 'package:firebase02/components/fireBareAuth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../components/custombuttonauth.dart';
import '../components/customformfiledauth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController Cusername = TextEditingController();
  TextEditingController Cemail = TextEditingController();
  TextEditingController Cpassword = TextEditingController();

  final _auth = Auth();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
          Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 30),
                const Text("SignUp",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                Container(height: 10),
                const Text("SignUp To Continue Using The App",
                    style: TextStyle(color: Colors.grey)),
                Container(height: 10),
                const CustomLogoAuth(),
                const Text(
                  "username",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(height: 10),
                CustomTextForm(
                  hinttext: "ُEnter Your username",
                  mycontroller: Cusername,
                  validator: (value) {
                    if (value == "") {
                      return 'username must not be empty';
                    }
                    return null;
                  },
                ),
                Container(height: 20),
                const Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(height: 10),
                CustomTextForm(
                  hinttext: "ُEnter Your Email",
                  mycontroller: Cemail,
                  validator: (value) {
                    if (value == "") {
                      return 'email must not be empty';
                    }
                    return null;
                  },
                ),
                Container(height: 10),
                const Text(
                  "Password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(height: 10),
                CustomTextForm(
                  hinttext: "ُEnter Your Password",
                  mycontroller: Cpassword,
                  validator: (value) {
                    if (value == "") {
                      return 'password must not be empty';
                    }
                    return null;
                  },
                ),
                Container(
                  height: 40,
                ),
              ],
            ),
          ),
          CustomButtonAuth(
              title: "SignUp",
              onPressed: () async {
                if (formkey.currentState!.validate()) {
                  try {
                    final result =
                        await _auth.signUp(Cemail.text, Cpassword.text);
                    FirebaseAuth.instance.currentUser!.sendEmailVerification();

                    Navigator.of(context).pushReplacementNamed('login');

                    print("=============================");
                    print(result.user!.uid);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                      AwesomeDialog(
                        context:context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: 'error',
                        desc: 'The password provided is too weak.',
                         ).show();
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                      AwesomeDialog(
                        context:context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: 'error',
                        desc: 'The account already exists for that email.',
                         ).show();
                    }
                  } catch (e) {
                    print(e);
                  }
                }
              }),
          Container(height: 20),

          // Text("Don't Have An Account ? Resister" , textAlign: TextAlign.center,)
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed("login");
            },
            child: const Center(
              child: Text.rich(TextSpan(children: [
                TextSpan(
                  text: "Already Have An Account ? ",
                ),
                TextSpan(
                    text: "Login",
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold)),
              ])),
            ),
          )
        ]),
      ),
    );
  }
}
