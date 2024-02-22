import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testproject/main.dart';
class addtofirebase extends StatefulWidget {
  const addtofirebase({super.key});

  @override
  State<addtofirebase> createState() => _addtofirebaseState();
}

class _addtofirebaseState extends State<addtofirebase> {
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late String _title = '';
  @override
  void initState() {
    _titleController=TextEditingController();
    _subtitleController=TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var _sub="";
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black12,
          title: TextField(
        onChanged: (value){
          _title=value;
        },
        controller: _titleController,
        decoration: InputDecoration.collapsed(hintText: 'Give a title')
      ),
          leading: IconButton(icon: Icon(Icons.arrow_back),
        onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Homepage()));
        },)),
      body: Container(
        child: TextField(
          onChanged: (value){
            _sub=value;
          },
          controller: _subtitleController,
          maxLines: null,
          decoration: InputDecoration(
            border: InputBorder.none
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        if(_sub.isNotEmpty) {

          FirebaseFirestore.instance.collection('2').add({
            'Subtitle':FirebaseFirestore.instance.collection('2').add({
              'Title':_title,
              'Subtitle':_sub

            })
          });
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Homepage()));
        }
      },
      child: Text("save",style: TextStyle(fontSize: 25),)),
    );
  }
}




