import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/auth_page.dart';
import 'package:diary/read_page.dart';
import 'package:diary/write_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import 'diary_list.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
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
            "$_name의 Diary 리스트",
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              child: const Icon(
                Icons.create,
                color: Colors.black,
              ),
              onTap: () {
                Get.to(() => const WritePage());
                // do something
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection(user!.uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }

              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final docs = snapshot.data!.docs;

              return ListView(
                children: docs.map((doc){
                  //Timestamp t = doc['datetime'];
                  DateTime date = DateTime.fromMillisecondsSinceEpoch(doc['datetime']);

                  //print(date.toString());
                  String str = date.toString().substring(0,16);
                  return DiaryList(title: doc['title'], text: doc['text'], time: str, user: _name, image: doc['imageURL'],);
                }).toList(),
              );

            }
        ),

        // ListView(
        //   children: const [
        //
        //     DiaryList(
        //       title: 'title',
        //     ),
        //     SizedBox(height: 10.0),
        //     DiaryList(
        //       title: 'title',
        //     ),
        //     SizedBox(height: 10.0),
        //     DiaryList(
        //       title: 'title',
        //     ),
        //     SizedBox(height: 10.0),
        //     DiaryList(
        //       title: 'title',
        //     ),
        //     SizedBox(height: 10.0),
        //     DiaryList(
        //       title: 'title',
        //     ),
        //     SizedBox(height: 10.0),
        //     DiaryList(
        //       title: 'title',
        //     ),
        //     SizedBox(height: 10.0),
        //     DiaryList(
        //       title: 'title',
        //     ),
        //     SizedBox(height: 10.0),
        //     DiaryList(
        //       title: 'title',
        //     ),
        //     SizedBox(height: 10.0),
        //     DiaryList(
        //       title: 'title',
        //     ),
        //     SizedBox(height: 10.0),
        //     DiaryList(
        //       title: 'title',
        //     ),
        //     SizedBox(height: 10.0),
        //     DiaryList(
        //       title: 'title',
        //     ),
        //     SizedBox(height: 10.0),
        //     DiaryList(
        //       title: 'title',
        //     ),
        //     SizedBox(height: 10.0),
        //     DiaryList(
        //       title: 'title',
        //     ),
        //     SizedBox(height: 10.0),
        //     DiaryList(
        //       title: 'title',
        //     ),
        //   ],
        // ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.logout, color: Colors.white),
        onPressed: () {
          _logout();
        },
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

  _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
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
