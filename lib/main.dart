import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:testproject/add_tiem.dart';
import 'package:testproject/detail.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCBLMjR7Opv64CRkfOAuWqULDNh4bMNi5A",
            appId: "1:677974677729:android:2d861c052318a91b1a3fa0",
            messagingSenderId: '1:677974677729',
            projectId: "testproject-cf024"));


    print('successfully initiallize');
    await FirebaseAuth.instance.signInAnonymously();
    print('SignInAnonymously successully');
    runApp(MyApp());
  } catch (e, stackTrace) {
    print('Error initializing Firebase: $e\n$stackTrace');
    // Handle error appropriately (e.g., show error message to user)
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.blue
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);


  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Stream<QuerySnapshot> _stream;
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.blue,
        statusBarBrightness: Brightness.dark
    ));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // Check if user is authenticated
    final User? user = _auth.currentUser;

    if (user != null) {
      _stream = _firestore
          .collection("notes")
          .where("userId", isEqualTo: user.uid)
          .snapshots();
    }

    return SafeArea(

      child: Scaffold(
        appBar: AppBar(
          title: Text("Notes"),
          centerTitle: true,
          backgroundColor: Colors.yellow,
        ),

        body: user == null
            ? Center(child: CircularProgressIndicator())
            : StreamBuilder(
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

            return Container(

              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView.builder(
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
                              extentRatio: 0.38,
                              children: [
                                SlidableAction(

                                  onPressed: (context) {
                                    _firestore
                                        .collection('notes')
                                        .doc(snapshot.data!.docs[Index].id)
                                        .delete();
                                  },

                                  backgroundColor: Colors.red,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                  borderRadius: BorderRadius.circular(20),

                                ),
                              ],
                            ),
                            child: ListTile(
                              title: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: 60
                                  ),
                                  child: Text(title[Index], style: TextStyle(fontSize: 30))),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 10,left: 2),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: 120
                                  ),

                                  child: Text(
                                    subtitle[Index],style: TextStyle(fontSize: 22),),
                                ),
                              ),

                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => Detail(document: snapshot.data!.docs[Index])),
                                );
                              },
                            ),
                          ),
                      ));

                  },
                ),
              ),
            );
          },
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddToFirebase()),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}