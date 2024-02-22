import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class detail extends StatefulWidget {

     final QueryDocumentSnapshot<Object?>docement;
    const detail({Key? key, required this.docement}) : super(key: key);


  @override
  State<detail> createState() => _detailState();
}

class _detailState extends State<detail> {
  late TextEditingController _titlecontroller;
  late TextEditingController _Subtitlecontroller;
  late String _initialText;
  late String title='';

  @override
  void initState() {
    super.initState();
    title=widget.docement['Title'] ?? '';
    _initialText = widget.docement['Subtitle'] ?? '';
    _titlecontroller =TextEditingController(text: title);
    _Subtitlecontroller = TextEditingController(text: _initialText);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value){
            title=value;
          },
          controller: _titlecontroller,
        ),
        backgroundColor: Colors.black12,),
      body:TextField(

        onChanged: (newval){
          setState(() {
            _initialText=newval;
          });
        },
        controller: _Subtitlecontroller,
        maxLines: null,
        decoration: InputDecoration(

          border: InputBorder.none
        ),
        style: TextStyle(fontSize: 28),


      ),
        floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
      if (_Subtitlecontroller.text != widget.docement['Subtitle']|| _titlecontroller.text!=widget.docement["Title"]) {
        widget.docement.reference.update({
          'Title':_titlecontroller.text,
          'Subtitle': _Subtitlecontroller.text});
      }
      Navigator.pop(context);
          }, label: Text("update",style: TextStyle(fontSize: 26),),
        ),
    );
  }
}



