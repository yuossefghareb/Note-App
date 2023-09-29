import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase02/components/appStyle.dart';
import 'package:firebase02/note/addnote.dart';
import 'package:firebase02/note/editnote.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ViewNote extends StatefulWidget {
  final String catgoreyid;
  const ViewNote({Key? key, required this.catgoreyid}) : super(key: key);

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  List data = [];

  bool isLoading = true;

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.catgoreyid)
        .collection('note')
        .get();

    data.addAll(querySnapshot.docs);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: AppStyle.mainColor,
        appBar: AppBar(
          leading: IconButton(
    icon: Icon(Icons.arrow_back, color: Colors.black),
    onPressed: () {
      Navigator.pushNamedAndRemoveUntil(
                  context, 'homePage', (route) => false);
              
    }
  ), 
          title: Text('Notes',style: TextStyle(fontSize: 24),),
          elevation: 0.0,
          centerTitle: true,
         backgroundColor: Colors.white,
          actions: [
            IconButton(
                onPressed: () async {
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  googleSignIn.disconnect();
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacementNamed('login');
                },
                icon: Icon(Icons.exit_to_app)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddNote(
                docid: widget.catgoreyid,
              ),
            ));
          },
          child: Icon(Icons.add),
        ),

        
        body:isLoading?Center(child: CircularProgressIndicator(),)
        :data.length==0? Center(child:Text('   No Notes \nAdd Your Notes',style: TextStyle(color: Colors.grey,fontSize: 30),),)
        : GridView.builder(
          
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisExtent: 250,),
          itemCount: data.length,
          itemBuilder: (context, index) {
            var color_id = 
                Random().nextInt(AppStyle.cardsColor.length);
            return InkWell(
              onTap: ()
              {
                Navigator.of(context).push(MaterialPageRoute(
                               builder: (context) => EditNote(
                              oldname: data[index]['note'],
                              cat_id: widget.catgoreyid,
                              doc_id_note: data[index].id,
                              oldtitle: data[index]['title'],
                              color: AppStyle.cardsColor[color_id],
                            )));
              },
              onLongPress: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.rightSlide,
                  btnOkOnPress: () async {
                     await FirebaseFirestore.instance
                      .collection('categories')
                      .doc(widget.catgoreyid).collection('note').doc(data[index].id)
                      .delete();
                 Navigator.of(context).push(MaterialPageRoute(
                               builder: (context) => ViewNote(
                             catgoreyid: widget.catgoreyid,
                            )));
                  },
                  btnCancelOnPress: () async {
                    
                  },
                  btnOkText: 'Delete',
                  btnCancelText: 'Cancel',
                  title: "error",
                  desc: 'Delete this Note?',
                ).show();
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  
                  color: AppStyle.cardsColor[
                      color_id],
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         
                          Text(
                            
                             '${data[index]['title']}',
                            style: TextStyle(
                                fontSize: 20,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold),
                            maxLines: 4,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Text(
                              '${data[index]['note']}',
                              style: TextStyle(
                                fontSize: 18,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 4,
                              textAlign: TextAlign.start,
                            ),
                          ),
                             SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                                Text(
                            '${data[index]['date']}',
                            style: TextStyle(
                                fontSize: 15,
                                overflow: TextOverflow.ellipsis),
                            maxLines: 7,
                          ),
              
                          Spacer(),
              
                          Container(
                            decoration: BoxDecoration(
                              color:   Colors.white,
                              borderRadius: BorderRadius.circular(70)),
                                            
                            child: IconButton(onPressed: (){
                               Navigator.of(context).push(MaterialPageRoute(
                               builder: (context) => EditNote(
                              oldname: data[index]['note'],
                              cat_id: widget.catgoreyid,
                              doc_id_note: data[index].id,
                              oldtitle: data[index]['title'],
                              color: AppStyle.cardsColor[color_id],
                            )));
                            },
                             icon: Icon(Icons.edit,color: Colors.grey,)),
                          ),
              
              
                            ],
                          ),
                          
                          
                         
                          
                        ]),
                  ),
                ),
              ),
            );
          },
        ),
        );
  }
}
