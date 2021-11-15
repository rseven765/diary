import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class ReadPage extends StatefulWidget {
  const ReadPage(
      {Key? key,
      required this.title,
      required this.text,
      required this.time,
      required this.user,
      required this.url})
      : super(key: key);

  final String title;
  final String time;
  final String text;
  final String user;
  final String url;

  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  String _name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.only(left: 5.0),
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 5.0, right: 16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                offset: Offset(4.0, 4.0),
                blurRadius: 15.0,
                spreadRadius: 1.0,
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(-4.0, -4.0),
                blurRadius: 15.0,
                spreadRadius: 1.0,
              ),
            ],
          ),
          child: ListView(
            children: [
              Row(
                children: [
                  const SizedBox(
                    child: Icon(Icons.person_outlined),
                    height: 60.0,
                    width: 50.0,
                  ),
                  const SizedBox(width: 5.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _name,
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        widget.time,
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.black12,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(thickness: 0.2, color: Colors.white),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Text(
                  widget.text,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(widget.url, fit: BoxFit.fill),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getUser() {
    // Cloud Firestore에서 name 가져오기
    FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        try {
          dynamic name = documentSnapshot.get(FieldPath(const ['name']));
          setState(() {
            _name = name;
          });
        } on StateError catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('사용자 이름을 가져올 수 없습니다.'),
            backgroundColor: Colors.deepOrange,
          ));
        }
      }
    });
  }
}
