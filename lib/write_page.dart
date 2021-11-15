import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class WritePage extends StatefulWidget {
  const WritePage({Key? key}) : super(key: key);

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  final User? _user = FirebaseAuth.instance.currentUser;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  late XFile _image;
  int _photo = 0;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.only(left: 5.0),
          child: const Text(
            "Diary 작성",
            style: TextStyle(
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 5.0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '제목',
                      isDense: true, // Added this
                      contentPadding: EdgeInsets.all(8), // Added this
                    ),
                    controller: _titleController,
                  ),
                  TextField(
                    maxLines: 20,
                    decoration: InputDecoration(
                      hintText: "내용을 입력하세요.",
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                    controller: _textController,
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  _photo == 0
                      ? Container()
                      : Container(
                    child: Image.file(File(_image.path)),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          if(_photo == 1)_photo = 0;
                          _getImage(ImageSource.gallery);
                        },
                        child: Column(
                          children: const [
                            Icon(Icons.add_a_photo_outlined),
                            Text(
                              '사진추가',
                              style: TextStyle(
                                fontSize: 8.0,
                                color: Colors.black45,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      OutlinedButton(
                        onPressed: () {
                          _submit();
                        },
                        child: const Text(
                          '등록',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  _submit() async {
    String downloadURL = '';
    //firebase 에 사진 등록
    String str = DateTime.now().millisecondsSinceEpoch.toString();
    File file = File(_image.path);
    try {

      await FirebaseStorage.instance
          .ref(_user!.uid+"/"+_titleController.text + "/" + str)
          .putFile(file);
      // 업로드한 사진의 URL 획득
      downloadURL = await FirebaseStorage.instance
          .ref(_user!.uid+"/"+_titleController.text + "/" + str)
          .getDownloadURL();


    } on FirebaseException catch (e) {
      print('$e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('$e'),
          backgroundColor: Colors.deepOrange,
      ));
    }



    CollectionReference diaryCollection =
        FirebaseFirestore.instance.collection(_user!.uid);
    // Cloud Firestore에 이름 등록
    diaryCollection.add({
      'title': _titleController.text,
      'text': _textController.text,
      'datetime': DateTime.now().millisecondsSinceEpoch,
      'imageURL': downloadURL,
    }).then((value) async {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('등록 완료.'),
        backgroundColor: Colors.blue,
      ));
      Get.back();
    }).catchError((error) async {
      print('$error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$error'),
        backgroundColor: Colors.deepOrange,
      ));
    });




  }

  Future<void> _getImage(ImageSource source) async {
    XFile image = (await _picker.pickImage(source: source))!;

    setState(() {
      _image = image;
      _photo = 1;
    });
  }


}
