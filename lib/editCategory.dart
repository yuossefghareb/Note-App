
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase02/components/custombuttonauth.dart';
import 'package:firebase02/components/customformfiledauth.dart';
import 'package:firebase02/components/customformfilledNote.dart';

import 'package:flutter/material.dart';

class EditCat extends StatefulWidget {
  final String oldname;
  final String doc_id;

  const EditCat({super.key, required this.oldname, required this.doc_id});
  @override
  State<EditCat> createState() => _AddCatState();
}

class _AddCatState extends State<EditCat> {
  GlobalKey<FormState> formkey = GlobalKey();

  var nameCotroller = TextEditingController();

  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  bool isLoading = false;

  Editcategories() async {
    if (formkey.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        await categories.doc(widget.doc_id).update({
          "name":nameCotroller.text,
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
  void initState() {
    super.initState();
    // TODO: implement initState
    nameCotroller.text = widget.oldname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
    icon: Icon(Icons.arrow_back, color: Colors.black),
    onPressed: () {
      Navigator.pushNamedAndRemoveUntil(
                  context, 'homePage', (route) => false);
              
    }),
        title: Text('Edit Cartogery Name',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
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
                      SizedBox(
                        height: 10,
                      ),
                      CustomButtonAuth(
                        title: 'Save',
                        onPressed: () {
                          Editcategories();
                        },
                      ),
                    ],
                  ),
          )),
    );
  }
}
