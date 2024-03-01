
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';


class AddToFirebase extends StatefulWidget {
  const AddToFirebase({Key? key}) : super(key: key);

  @override
  State<AddToFirebase> createState() => _AddToFirebaseState();
}

class _AddToFirebaseState extends State<AddToFirebase> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height/10,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40, left:45),
                      child: TextField(
                        style: TextStyle(fontSize: 30),
                        controller: _titleController,
                        maxLength: 60,
                        decoration: InputDecoration(
                          hintText: "Title",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -2, // Adjust this value as needed to position the button
                    left:2, // Adjust this value as needed to position the button
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),

              Expanded(
                child: ListView(
                  children:[ TextField(


                    controller: _subtitleController,
                    style: TextStyle(fontSize: 28),
                    decoration: InputDecoration(
                      hintText: "Title will not save withour this any data",
                    border: InputBorder.none
                    ),
                    maxLines: null,



                  ),
                ]),
              ),
            ],
          ),
        floatingActionButton: FloatingActionButton(
          onPressed: ()  {

              final User? user = FirebaseAuth.instance.currentUser;
              final subtitle = _subtitleController.text.trim();
              print("Subtitle: '$subtitle'");
              if (user != null && subtitle.isNotEmpty) {
                 FirebaseFirestore.instance.collection('notes').add({
                  'userId': user.uid,
                  'Title': _titleController.text,
                  'Subtitle': subtitle,
                });
              }
                Navigator.pop(context);
              },

          child: Text("Save",style: TextStyle(fontSize: 20),),
        ),
    ));
  }
}

