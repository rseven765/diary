import 'package:diary/read_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class DiaryList extends StatefulWidget {
  const DiaryList(
      {Key? key,
      required this.title,
      required this.text,
      required this.time,
      required this.user,
      required this.image})
      : super(key: key);

  final String title;
  final String time;
  final String text;
  final String user;
  final String image;

  @override
  State<DiaryList> createState() => _DiaryListState();
}

class _DiaryListState extends State<DiaryList> {
  String _url = 'assets/images/2.png';
  String _title = '';
  String _time = '';
  String _text = '';
  String _user = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), //모서리를 둥글게
        border: Border.all(color: Colors.black12, width: 1),
      ),
      child: GestureDetector(
        onTap: () => Get.to(() => ReadPage(
              time: _time,
              text: _text,
              title: _title,
              user: _user,
              url: _url,
            )),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: _url == 'assets/images/2.png'
                    ? Image(
                        image: AssetImage(_url),
                        fit: BoxFit.fill,
                      )
                    : Image.network(_url, height: 120.0, fit: BoxFit.fill),
              ),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.time,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.black12,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    widget.user,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
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
    _getPath();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getPath() {
    setState(() {
      _url = widget.image;
      _text = widget.text;
      _title = widget.title;
      _time = widget.time;
      _user = widget.user;
    });
  }
}
