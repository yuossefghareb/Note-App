import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase02/components/custombuttonauth.dart';
import 'package:firebase02/note/viewnote.dart';

import 'package:flutter/material.dart';

class EditNote extends StatefulWidget {
  final String oldname;
  final String oldtitle;
  final String doc_id_note;
  final String cat_id;
  final Color? color;

  const EditNote(
      {super.key,
      required this.oldname,
      required this.doc_id_note,
      required this.cat_id,
      this.color,
      required this.oldtitle});
  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  GlobalKey<FormState> formkey = GlobalKey();

  var nameCotroller = TextEditingController();
  var titleCotroller = TextEditingController();
  bool isLoading = false;

  EditNote() async {
    CollectionReference categories = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.cat_id)
        .collection('note');
    if (formkey.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        await categories.doc(widget.doc_id_note).update({
          "note": nameCotroller.text,
          "title":titleCotroller.text,
        });

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => ViewNote(catgoreyid: widget.cat_id),
            ),
            (route) => false);
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
    titleCotroller.text = widget.oldtitle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: widget.color,
      ),
      body: Form(
          key: formkey,
          child: Container(
            color: widget.color,
            padding: EdgeInsets.all(10),
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListView(
                      children: [
                        TextFormField(
                          
                          controller: titleCotroller,
                          style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,),textAlign: TextAlign.center,
                          keyboardType: TextInputType.text,
                          maxLines: null,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: 'Title'),
                        ),
                        SizedBox(height: 5,),
                        TextFormField(
                          controller: nameCotroller,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Note Content'),
                        ),
                        /*
                        CustomTextForm(
                          hinttext: 'Enter  node',
                          mycontroller: nameCotroller,
                          validator: (value) {
                            if (value == "") {
                              return 'name must not bet empty';
                            }
                            return null;
                          },
                        ),
                        */
                        SizedBox(
                          height: 10,
                        ),
                        CustomButtonAuth(
                          title: 'Save',
                          onPressed: () {
                            EditNote();
                          },
                        ),
                      ],
                    ),
                  ),
          )),
    );
  }
}
