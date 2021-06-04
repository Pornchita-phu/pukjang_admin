import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:pukjangg_adminn/model/Logo.dart';
import 'package:pukjangg_adminn/service/Storage.dart';

class AddSkin extends StatefulWidget {
  @override
  _AddSkinState createState() => _AddSkinState();
}

class _AddSkinState extends State<AddSkin> {
  String select;
  TextEditingController name = new TextEditingController();
  TextEditingController detail = new TextEditingController();
  TextEditingController price = new TextEditingController();
  final Storage storage = new Storage();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final databaseReference = FirebaseDatabase.instance.reference();
  List<Logo> logo = [];
  File _image;
  final _picker = ImagePicker();
  String img1;
  var vimg1;
  String title = "เพิ่มลายปัก";
  int s = 0;
  String firstname = "no",
      lastname = "no",
      firstnameEN = "no",
      lastnameEN = "no",
      nickname = "no",
      studentid = "no";
  bool fn = false,
      ln = false,
      fnEN = false,
      lnEN = false,
      nn = false,
      stuid = false;
  Future getImage() async {
    var image = await _picker.getImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path.toString());
      });
    }
  }

  void setLogo() {
    databaseReference.child("Logo").once().then((DataSnapshot dataSnapshot) {
      logo.clear();
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;

      for (var key in keys) {
        Logo lg = new Logo(
            values[key]['detail'],
            values[key]['firstname'],
            values[key]['firstnameEN'],
            values[key]['lastname'],
            values[key]['lastnameEN'],
            values[key]['name'],
            values[key]['nickname'],
            double.parse(values[key]['price'].toString()),
            values[key]['studentid'],
            values[key]['type'],
            values[key]['url'],
            values[key]['userid'],
            values[key]['id']);
        setState(() {
          logo.add(lg);
        });
      }
    });
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

  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(),
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.orangeAccent,
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: SizedBox(
                      width: 500.0,
                      child: TextFormField(
                        controller: name,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          hintText: 'ชื่อลาย',
                          filled: true,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'กรุณากรอกชื่อลาย';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  controller: detail,
                  decoration: InputDecoration(
                    hintText: 'รายละเอียด',
                    filled: true,
                  ),
                  minLines: 4,
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'กรุณากรอกรายละเอียด';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: DropdownButton(
                      hint: Text("ประเภทลาย",
                          style: TextStyle(color: Colors.black)),
                      value: select,
                      items: ["ลายโรงเรียน", "ลายอื่นๆ"]
                          .map((value) => DropdownMenuItem(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Text(value),
                                ),
                                value: value,
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          select = value;
                        });
                      },
                    ),
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: fn,
                      onChanged: (value) {
                        setState(() {
                          fn = value;
                        });
                        if (fn) {
                          setState(() {
                            firstname = "yes";
                          });
                        } else {
                          setState(() {
                            firstname = "no";
                          });
                        }
                      },
                    ),
                    Text('ชื่อ'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: ln,
                      onChanged: (value) {
                        setState(() {
                          ln = value;
                        });
                        if (ln) {
                          setState(() {
                            lastname = "yes";
                          });
                        } else {
                          lastname = "no";
                        }
                      },
                    ),
                    Text('นามสกุล'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: fnEN,
                      onChanged: (value) {
                        setState(() {
                          fnEN = value;
                        });
                        if (fnEN) {
                          setState(() {
                            firstnameEN = "yes";
                          });
                        } else {
                          setState(() {
                            firstnameEN = "no";
                          });
                        }
                      },
                    ),
                    Text('ชื่อจริงภาาาอังกฤษ'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: lnEN,
                      onChanged: (value) {
                        setState(() {
                          lnEN = value;
                        });
                        if (lnEN) {
                          setState(() {
                            lastnameEN = "yes";
                          });
                        } else {
                          setState(() {
                            lastnameEN = "no";
                          });
                        }
                      },
                    ),
                    Text('นามสกุลภาษาอังกฤษ'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: nn,
                      onChanged: (value) {
                        setState(() {
                          nn = value;
                        });
                        if (nn) {
                          setState(() {
                            nickname = "yes";
                          });
                        } else {
                          setState(() {
                            nickname = "no";
                          });
                        }
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
                        if (stuid) {
                          setState(() {
                            studentid = "yes";
                          });
                        } else {
                          setState(() {
                            studentid = "no";
                          });
                        }
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
                      SizedBox(
                        width: 100.0,
                        child: TextFormField(
                          controller: price,
                          autofocus: false,
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'ราคา',
                            hintStyle: TextStyle(
                                fontSize: 20.0, color: Colors.redAccent),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'กรุณาใส่ราคา';
                            }
                            return null;
                          },
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: const Color(0xff0177ff))),
                            primary: Colors.red),
                        onPressed: () {
                          if (_formkey.currentState.validate() &&
                              select != null) {
                            storage.createLogo(
                                detail.text,
                                firstname,
                                firstnameEN,
                                lastname,
                                lastnameEN,
                                name.text,
                                nickname,
                                double.parse(price.text.toString()),
                                studentid,
                                select,
                                "no",
                                vimg1,
                                img1);
                            setState(() {
                              detail.clear();
                              name.clear();
                              price.clear();
                              select = null;
                              firstname = "no";
                              lastname = "no";
                              firstnameEN = "no";
                              lastnameEN = "no";
                              nickname = "no";
                              studentid = "no";
                              fn = false;
                              ln = false;
                              fnEN = false;
                              lnEN = false;
                              nn = false;
                              stuid = false;
                              _image = null;
                              img1 = null;
                              vimg1 = null;
                            });
                            showSimpleSnackbar("เพิ่มลายปักสำเร็จ", context);
                          }
                        },
                        child: Text(
                          'เพิ่ม',
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
        )),
      ),
    );
  }
}
