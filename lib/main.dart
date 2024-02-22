import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testproject/add_tiem.dart';
import 'package:testproject/detail.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyCBLMjR7Opv64CRkfOAuWqULDNh4bMNi5A",
          appId: "1:677974677729:android:2d861c052318a91b1a3fa0",
          messagingSenderId: '1:677974677729',
          projectId: "testproject-cf024"));
  print("successflull");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      home: Homepage(),
    );
  }
}

class Homepage extends StatelessWidget {
  Homepage({super.key});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _stream = _firestore.collection("2").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _stream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print("error: ${snapshot.error}");
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No data available"));
          }


          final title= snapshot.data!.docs.map((e) => e['Title']).toList();
          final subtitle= snapshot.data!.docs.map((e) => e['Subtitle']).toList();


          return ListView.builder(
            itemCount: title.length,
            itemBuilder: (context, Index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(Radius.circular(35))
                  ),
                  child: Slidable(
                    endActionPane: ActionPane(
                      motion: const BehindMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            _firestore
                                .collection('2')
                                .doc(snapshot.data!.docs[Index].id)
                                .delete();
                          },
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          label: 'Delete',

                        ),
                      ],
                    ),
                    child: ListTile(

                      title: Text(title[Index], style: TextStyle(fontSize: 30)),
                      subtitle: Text(subtitle[Index],style: TextStyle(fontSize: 22),),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          CupertinoPageRoute(

                              builder: (context) => detail(docement: snapshot.data!.docs[Index])),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => addtofirebase()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
