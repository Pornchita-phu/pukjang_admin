import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:pukjangg_adminn/service/Storage.dart';

class AddSkinUser extends StatefulWidget {
  final String id, userid, name, price;
  AddSkinUser({this.id, this.userid, this.name, this.price});
  @override
  _AddSkinUserState createState() => _AddSkinUserState();
}

class _AddSkinUserState extends State<AddSkinUser> {
  bool firstname = false,
      lastname = false,
      firstnameEN = false,
      lastnameEN = false,
      nickname = false,
      stuid = false;
  String fn = "no", ln = "no", fnEN = "no", lnEN = "no", nn = "no", sid = "no";
  File _image;
  final _picker = ImagePicker();
  String img1;
  var vimg1;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Storage storage = new Storage();
  final _formkey = GlobalKey<FormState>();
  TextEditingController detail = new TextEditingController();

  Future getImage() async {
    var image = await _picker.getImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path.toString());
      });
    }
  }

  createSkin() {
    if (firstname) {
      setState(() {
        fn = "yes";
      });
    }
    if (lastname) {
      setState(() {
        ln = "yes";
      });
    }
    if (firstnameEN) {
      setState(() {
        fnEN = "yes";
      });
    }
    if (lastnameEN) {
      setState(() {
        lnEN = "yes";
      });
    }
    if (nickname) {
      setState(() {
        nn = "yes";
      });
    }
    if (stuid) {
      setState(() {
        sid = "yes";
      });
    }
    storage.createLogo(detail.text, fn, fnEN, ln, lnEN, widget.name, nn,
        double.parse(widget.price), sid, "อื่นๆ", widget.userid, vimg1, img1);
    storage.updateSkinStatus(widget.id, "ทางร้านเพิ่มลายปักแล้ว");
  }

  void showSimpleSnackbar(String txt, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
          content: new Text(txt,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.deepOrangeAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("กลับ"),
          leading: IconButton(
            icon: Icon(Icons.navigate_before),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.orangeAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("เพิ่มลายปัก " + widget.name,
                        style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: InkWell(
                    onTap: () {
                      getImage();
                      setState(() {
                        img1 = basename(_image.path);
                        vimg1 = _image;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        (img1 == null)
                            ? Icon(
                                Icons.insert_photo_rounded,
                                size: 100,
                              )
                            : Image.file(
                                vimg1,
                                fit: BoxFit.cover,
                                height: 140,
                                width: 140,
                              ),
                      ],
                    )),
              ),
              Form(
                key: _formkey,
                child: TextFormField(
                    controller: detail,
                    onEditingComplete: () => FocusScope.of(context).unfocus(),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'กรุณาใส่รายละเอียดลายปัก';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'รายละเอียด',
                      filled: true,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 3),
              ),
              Row(
                children: [
                  Checkbox(
                    value: firstname,
                    onChanged: (value) {
                      setState(() {
                        firstname = value;
                      });
                    },
                  ),
                  Text('ชื่อ'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: lastname,
                    onChanged: (value) {
                      setState(() {
                        lastname = value;
                      });
                    },
                  ),
                  Text('นามสกุล'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: firstnameEN,
                    onChanged: (value) {
                      setState(() {
                        firstnameEN = false;
                      });
                    },
                  ),
                  Text('ชื่อจริงภาาาอังกฤษ'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: lastnameEN,
                    onChanged: (value) {
                      setState(() {
                        lastnameEN = value;
                      });
                    },
                  ),
                  Text('นามสกุลภาษาอังกฤษ'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: nickname,
                    onChanged: (value) {
                      setState(() {
                        nickname = value;
                      });
                    },
                  ),
                  Text('ชื่อเล่น'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: stuid,
                    onChanged: (value) {
                      setState(() {
                        stuid = value;
                      });
                    },
                  ),
                  Text('รหัสนักเรียน'),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "ราคา " + widget.price + " บาท",
                      style: TextStyle(fontSize: 18),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: const Color(0xff0177ff))),
                        primary: Colors.redAccent,
                      ),
                      onPressed: () {
                        if (vimg1 != null && _formkey.currentState.validate()) {
                          createSkin();
                          Navigator.pop(context);
                        } else {
                          showSimpleSnackbar(
                              "กรุณาใส่รูปและกรอกรายละเอียด", context);
                        }
                      },
                      child: Text(
                        'เพิ่มลายปัก',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
