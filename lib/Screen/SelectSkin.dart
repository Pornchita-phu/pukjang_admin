import 'package:flutter/material.dart';
import 'package:pukjangg_adminn/service/Storage.dart';

class SelectSkin extends StatefulWidget {
  final String detail, id, img, name, type, userid;
  SelectSkin(
      {this.detail, this.id, this.img, this.name, this.type, this.userid});
  @override
  _SelectSkinState createState() => _SelectSkinState();
}

class _SelectSkinState extends State<SelectSkin> {
  Storage storage = new Storage();
  bool can = false, cant = false;
  String select;

  final _formkey = GlobalKey<FormState>();
  TextEditingController price = new TextEditingController();
  TextEditingController becrouse = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("รายการเสนอลายปักชื่อ "),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(8, 12, 8, 0),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("ชื่อลาย ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(widget.name, style: TextStyle(fontSize: 16))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("ประเภท ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(widget.type, style: TextStyle(fontSize: 16))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("รายละเอียด ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Flexible(
                      child: Text(widget.detail,
                          maxLines: 3, style: TextStyle(fontSize: 16))),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("รูปภาพ ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Container(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Image.network(
                      widget.img,
                      height: 250,
                      width: 250,
                    ),
                  )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        onChanged: (bool value) {
                          setState(() {
                            can = value;
                            select = null;
                          });
                          if (can) {
                            setState(() {
                              cant = false;
                              select = "yes";
                            });
                          }
                        },
                        value: can,
                      ),
                      Text(
                        "สามารถทำลายปักได้",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        onChanged: (bool value) {
                          setState(() {
                            cant = value;
                            select = null;
                          });
                          if (cant) {
                            setState(() {
                              can = false;
                              select = "no";
                            });
                          }
                        },
                        value: cant,
                      ),
                      Text(
                        "ไม่สามารถทำลายปักได้",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 5),
                child: can == true && cant == false && widget.type == "ลายอื่นๆ"
                    ? Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text("ราคา ",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                  padding: EdgeInsets.only(left: 12, right: 12),
                                  width: 150,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: price,
                                    decoration: InputDecoration(
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
                                Text("บาท ",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Row(
                              children: [
                                Text("รายละเอียด ",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                  padding: EdgeInsets.only(left: 12),
                                  width: 300,
                                  child: TextFormField(
                                    maxLines: 2,
                                    controller: becrouse,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'กรุณากรอกรายละเอียด';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    : can == false && cant == true
                        ? Row(
                            children: [
                              Text("สาเหตุ ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                padding: EdgeInsets.only(left: 12),
                                width: 300,
                                child: Form(
                                  key: _formkey,
                                  child: TextFormField(
                                    maxLines: 2,
                                    controller: becrouse,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'กรุณากรอกสาเหตุ';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(),
              ),
              can == false && cant == false
                  ? Container()
                  : Container(
                      padding: EdgeInsets.only(top: 12),
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary:Colors.blueAccent
                        ),
                        onPressed: () {
                          if (select == "yes" &&
                              _formkey.currentState.validate()) {
                            if (widget.type == "ลายอื่นๆ") {
                              storage.updateSkin(select,widget.id,
                                  double.parse(price.text), becrouse.text);
                            } else if (widget.type == "ลายโรงเรียน") {
                              storage.updateSkin(select,
                                  widget.id,0.0, "null");
                            }
                          } else if (select == "no" &&
                              _formkey.currentState.validate()) {
                            storage.updateSkin(select,widget.id, 0.0,becrouse.text);
                          }
                          Navigator.pop(context);
                        },
                        child: Text(
                          "ตอบกลับ",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
