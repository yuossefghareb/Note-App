import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase02/components/custombuttonauth.dart';
import 'package:firebase02/components/customformfiledauth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddCat extends StatefulWidget {
  const AddCat({super.key});

  @override
  State<AddCat> createState() => _AddCatState();
}

class _AddCatState extends State<AddCat> {
  GlobalKey<FormState> formkey = GlobalKey();

  var nameCotroller = TextEditingController();

  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  bool isLoading = false;

  addUser() async {
    if (formkey.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        DocumentReference response = await categories.add({
          "name":nameCotroller.text,
          "id":FirebaseAuth.instance.currentUser?.uid,
        });

        Navigator.of(context)
            .pushNamedAndRemoveUntil('homePage', (route) => false);
      } catch (e) {
        isLoading = false;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, 'homePage', (route) => false);
          },
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          'Add New Cartogery',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
          key: formkey,
          child: Container(
            padding: EdgeInsets.all(20),
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      CustomTextForm(
                        hinttext: 'Enter Name',
                        mycontroller: nameCotroller,
                        validator: (value) {
                          if (value == "") {
                            return 'name must not bet empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomButtonAuth(
                        title: 'Add',
                        onPressed: () {
                          addUser();
                        },
                      ),
                    ],
                  ),
          )),
    );
  }
}
