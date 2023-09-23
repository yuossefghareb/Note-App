import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase02/components/custombuttonauth.dart';

import 'package:firebase02/note/viewnote.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddNote extends StatefulWidget {
  final String docid;

  const AddNote({super.key, required this.docid});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  GlobalKey<FormState> formkey = GlobalKey();

  var nameCotroller = TextEditingController();
  var titleCotroller = TextEditingController();

  bool isLoading = false;

  addUser() async {
    if (formkey.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        CollectionReference notes = FirebaseFirestore.instance
            .collection('categories')
            .doc(widget.docid)
            .collection('note');

        DocumentReference response = await notes.add({
          "note": nameCotroller.text,
          "title": titleCotroller.text,
          "date": DateFormat(' EEE d MMM').format(DateTime.now()),
        });

        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => ViewNote(catgoreyid: widget.docid)));
      } catch (e) {
        isLoading = false;
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameCotroller.dispose();
    titleCotroller.dispose();
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
        title: Text('Add New Note',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
      ),
      body: Form(
          key: formkey,
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  children: [
                   

                    Container(
                      padding: EdgeInsets.all(24.0),
                      color: Colors.white,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: titleCotroller,
                            style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.text,
                            maxLines: null,
                            validator: (value) {
                              if (value == "") {
                                return 'name must not bet empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: 'Title'),
                          ),
                          SizedBox(height: 8,),
                          TextFormField(
                        controller: nameCotroller,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        validator: (value) {
                          if (value == "") {
                            return 'name must not bet empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: 'Note Content'),
                      ),
                        ],
                      ),
                    ),
                    
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(24.0),
                      child: CustomButtonAuth(
                        title: 'Add',
                        onPressed: () {
                          addUser();
                        },
                      ),
                    ),
                  ],
                )),
    );
  }
}
