 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class Detail extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> document;

  const Detail({Key? key, required this.document}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late String _initialTitle;
  late String _initialSubtitle;
  late String _newTitle;
  late String _newSubtitle;
  

  @override
  void initState() {
    super.initState();
    _initialTitle = widget.document['Title'] ?? '';
    _initialSubtitle = widget.document['Subtitle'] ?? '';
    _newTitle = _initialTitle;
    _newSubtitle = _initialSubtitle;
    _titleController = TextEditingController(text: _newTitle);
    _subtitleController = TextEditingController(text: _newSubtitle);
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height/10,
              color: Colors.black12,
                child: Stack(
                  children: [
                    Padding(
                      
                      padding: EdgeInsets.only(left: 40),
                      child: TextField(
                        decoration: InputDecoration(border: InputBorder.none),
                        style: TextStyle(fontSize: 30),
                        maxLength: 60,
                        onChanged: (value) {
                          setState(() {
                            _newTitle = value;
                          });
                        },
                        controller: _titleController,
                      ),
                    ),
                    Positioned(
                      left: 2,
                      top: -2,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back),
                      ),
                    ),
                  ],
                ),
            ),
            Expanded(
              child: ListView(
                children: [
                  TextField(
                    onChanged: (newVal) {
                      setState(() {
                        _newSubtitle = newVal;
                      });
                    },
                    controller: _subtitleController,
                    maxLines: null,
                    decoration: InputDecoration(border: InputBorder.none),
                    style: TextStyle(fontSize: 32),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (_newTitle != _initialTitle || _newSubtitle != _initialSubtitle) {
              if (user != null) {
                widget.document.reference.update({
                  'Title': _newTitle,
                  'Subtitle': _newSubtitle,
                });
              }
            }
            Navigator.pop(context);
          },
          label: Text(
            "Update",
            style: TextStyle(fontSize: 26),
          ),
        ),
      ),
    );
  }
}
