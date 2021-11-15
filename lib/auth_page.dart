import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/skeleton/demo.dart';
import 'package:diary/list_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();
  final TextEditingController _registEmailController = TextEditingController();
  final TextEditingController _registPasswordController =
      TextEditingController();
  final TextEditingController _registPassword2Controller =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  int pagenumber = 0;

  Widget _loginWidget() {
    return Column(
      children: [
        const Center(
          child: Text(
            '로그인',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.blue,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          decoration: const InputDecoration(
            labelText: "아이디",
            border: OutlineInputBorder(),
          ),
          style: const TextStyle(color: Colors.blue),
          obscureText: false,
          controller: _loginEmailController,
          validator: (String? value) {
            if (value!.isEmpty) {
              return '이메일를 입력해주세요.';
            } else if (!EmailValidator.validate(value)) {
              return '올바른 형식의 이메일를 입력해주세요.';
            }
            return null;
          },
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          decoration: const InputDecoration(
            labelText: "비밀번호",
            border: OutlineInputBorder(),
          ),
          style: const TextStyle(color: Colors.blue),
          obscureText: true,
          controller: _loginPasswordController,
          validator: (String? value) {
            if (value!.isEmpty) {
              return '비밀번호를 입력해주세요.';
            }
            return null;
          },
        ),
        const SizedBox(height: 20.0),
        SizedBox(
          height: 50.0,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                FocusScope.of(context).requestFocus(FocusNode());
                printInfo(info: _loginEmailController.text);
                _login();
              }
            },
            child: const Text('로그인'),
          ),
        ),
        const SizedBox(height: 30.0),
      ],
    );
  }

  Widget _registWidget() {
    return Column(
      children: [
        const Center(
          child: Text(
            '회원 가입',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.blue,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          decoration: const InputDecoration(
            labelText: "이름",
            border: OutlineInputBorder(),
          ),
          style: const TextStyle(color: Colors.blue),
          obscureText: false,
          controller: _nameController,
          validator: (String? value) {
            if (value!.isEmpty) {
              return '이름을 입력해주세요.';
            }
            return null;
          },
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          decoration: const InputDecoration(
            labelText: "이메일",
            border: OutlineInputBorder(),
          ),
          style: const TextStyle(color: Colors.blue),
          obscureText: false,
          controller: _registEmailController,
          validator: (String? value) {
            if (value!.isEmpty) {
              return '이메일를 입력해주세요.';
            } else if (!EmailValidator.validate(value)) {
              return '올바른 형식의 이메일를 입력해주세요.';
            }
            return null;
          },
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          decoration: const InputDecoration(
            labelText: "비밀번호",
            border: OutlineInputBorder(),
          ),
          style: const TextStyle(color: Colors.blue),
          obscureText: true,
          controller: _registPasswordController,
          validator: (String? value) {
            if (value!.isEmpty) {
              return '비밀번호를 입력해주세요.';
            }
            return null;
          },
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          decoration: const InputDecoration(
            labelText: "비밀번호 확인",
            border: OutlineInputBorder(),
          ),
          style: const TextStyle(color: Colors.blue),
          obscureText: true,
          controller: _registPassword2Controller,
          validator: (String? value) {
            if (value!.isEmpty) {
              return '비밀번호를 확인 해주세요.';
            }
            return null;
          },
        ),
        const SizedBox(height: 20.0),
        SizedBox(
          height: 50.0,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                FocusScope.of(context).requestFocus(FocusNode());
                _join();
              }
            },
            child: const Text('제출'),
          ),
        ),
        const SizedBox(height: 30.0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Container(
        //컨테이너로 감싼다.
        decoration: const BoxDecoration(
            //decoration 을 준다.
            image: DecorationImage(
                image: AssetImage("assets/images/main.jpg"),
                fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent, //스캐폴드에 백그라운드를 투명하게 한다.
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text('Diary'),
            centerTitle: true,
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  pagenumber == 0 ? _loginWidget() : _registWidget(),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: pagenumber == 0
                ? const Icon(Icons.person_add, color: Colors.white)
                : const Icon(Icons.vpn_key, color: Colors.white),
            onPressed: () {
              if (pagenumber == 0) {
                setState(() {
                  pagenumber += 1;
                });
              } else {
                setState(() {
                  pagenumber -= 1;
                });
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        Get.offAll(() => const ListPage());
      });
    }
  }

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registEmailController.dispose();
    _registPasswordController.dispose();
    _registPassword2Controller.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loginEmailController.text,
          password: _loginPasswordController.text);
      Get.offAll(() => const ListPage());
    } on FirebaseAuthException catch (e) {
      String message = '사용자 로그인 실패';
      if (e.code == 'user-not-found') {
        message = '사용자가 존재하지 않습니다.';
      } else if (e.code == 'wrong-password') {
        message = '비밀번호를 확인하세요.';
      }

      final snackBar = SnackBar(
        content: Text(message),
        backgroundColor: Colors.deepOrange,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _join() async {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('user');

    try {
      // Authenciation에 이메일,비밀번호 등록
      final User? user = (await _auth.createUserWithEmailAndPassword(
              email: _registEmailController.text,
              password: _registPasswordController.text))
          .user;

      // Cloud Firestore에 이름 등록
      userCollection.doc(user!.uid).set({
        'name': _nameController.text,
      }).then((value) async {
        await FirebaseAuth.instance.signOut();
        pagenumber -= 1;
      }).catchError((error) async {
        print('$error');
        await FirebaseAuth.instance.currentUser!.delete();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.deepOrange,
        ));
      });
    } on FirebaseAuthException catch (e) {
      String message = '사용자 등록 실패';
      if (e.code == 'weak-password') {
        message = '비밀번호는 6자리 이상으로 해주세요.';
      } else if (e.code == 'email-already-in-use') {
        message = '이미 사용중인 이메일 입니다.';
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.deepOrange,
      ));
    }
  }
}
