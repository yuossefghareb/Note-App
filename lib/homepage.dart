import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase02/editCategory.dart';
import 'package:firebase02/note/viewnote.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List data = [];

  bool isLoading = true;

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
      //   backgroundColor:AppStyle.bgColor,
      appBar: AppBar(
        title: Text(
          'Folders',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
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
          Navigator.of(context).pushNamed('addCat');
        },
        child: Icon(Icons.add),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : data.length == 0
              ? Center(
                  child: Text(
                    '   No Folders \nAdd Your Folders',
                    style: TextStyle(color: Colors.grey, fontSize: 30),
                  ),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisExtent: 160),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ViewNote(catgoreyid: data[index].id),
                        ));
                       // Get.to(ViewNote(catgoreyid: data[index].id));
                      },
                      onLongPress: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.question,
                          animType: AnimType.rightSlide,
                          btnOkOnPress: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditCat(
                                    oldname: data[index]['name'],
                                    doc_id: data[index].id)));
                            print('ok');
                          },
                          btnCancelOnPress: () async {
                            await FirebaseFirestore.instance
                                .collection('categories')
                                .doc(data[index].id)
                                .delete();
                            Navigator.of(context)
                                .pushReplacementNamed('homePage');
                          },
                          btnOkText: 'Edit',
                          btnCancelText: 'Delete',
                          title: "Chosse you want",
                        ).show();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Card(
                          child: Column(children: [
                            Container(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.folder,
                                size: 80,
                              ),
                            ),
                            Text(
                              '${data[index]['name']}',
                              style:
                                  TextStyle(fontSize: 22, color: Colors.black),
                            )
                          ]),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
