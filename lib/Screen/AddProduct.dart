import 'dart:io';

import 'package:custom_switch/custom_switch.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:pukjangg_adminn/model/Product.dart';

import 'package:pukjangg_adminn/service/Storage.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  File _image;
  final _picker = ImagePicker();
  String img1, img2, img3;
  String select;
  var vimg1, vimg2, vimg3;
  int s = 0;
  List<Product> product = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final databaseReference = FirebaseDatabase.instance.reference();
  final _formkey = GlobalKey<FormState>();
  TextEditingController pdname = new TextEditingController();
  TextEditingController pdsizeS = new TextEditingController();
  TextEditingController pdsizeM = new TextEditingController();
  TextEditingController pdsizeL = new TextEditingController();
  TextEditingController pdsizeXL = new TextEditingController();
  String title = "เพิ่มสินค้า";
  Storage storage = new Storage();
  String status;
  bool swicth;
  Future getImage() async {
    var image = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = File(image.path);
      }
    });
  }

  createProduct() {
    storage.addProductData(img1, img2, img3, vimg1, vimg2, vimg3, pdname.text,
        pdsizeS.text, pdsizeM.text, pdsizeL.text, pdsizeXL.text, select);
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

  void setProduct() {
    databaseReference
        .child("Products")
        .once()
        .then((DataSnapshot dataSnapshot) {
      product.clear();
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;

      for (var key in keys) {
        if (values[key]['status'] == "ready") {
          setState(() {
            status = "พร้อมใช้งาน";
            swicth = true;
          });
        } else {
          setState(() {
            status = "ไม่พร้อมใช้งาน";
            swicth = false;
          });
        }
        Product pd = new Product(
            values[key]['id'],
            values[key]['name'],
            values[key]['image1'],
            values[key]['image2'],
            values[key]['image3'],
            double.parse(values[key]['sizeS'].toString()),
            double.parse(values[key]['sizeM'].toString()),
            double.parse(values[key]['sizeL'].toString()),
            double.parse(values[key]['sizeXL'].toString()),
            status,
            swicth);
        setState(() {
          product.add(pd);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
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
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: s,
            onTap: (index) {
              setState(() {
                s = index;
              });
              if (s == 0) {
                setState(() {
                  title = "เพิ่มสินค้า";
                });
              } else {
                setState(() {
                  title = "ลบสินค้า";
                });
                setProduct();
              }
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  label: "เพิ่มสินค้า", icon: Icon(Icons.edit)),
              BottomNavigationBarItem(
                  label: "ลบสินค้า", icon: Icon(Icons.remove_circle)),
            ],
          ),
          body: s == 0
              ? Form(
                  key: _formkey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                getImage();
                                img1 = basename(_image.path);
                                vimg1 = _image;
                              },
                              child: (vimg1 != null)
                                  ? Image.file(
                                      vimg1,
                                      fit: BoxFit.cover,
                                      height: 120,
                                      width: 120,
                                    )
                                  : Icon(
                                      Icons.insert_photo_rounded,
                                      size: 100,
                                    ),
                            ),
                            InkWell(
                              onTap: () {
                                getImage();
                                img2 = basename(_image.path);
                                vimg2 = _image;
                              },
                              child: (vimg2 != null)
                                  ? Image.file(
                                      vimg2,
                                      fit: BoxFit.cover,
                                      height: 120,
                                      width: 120,
                                    )
                                  : Icon(
                                      Icons.insert_photo_rounded,
                                      size: 100,
                                    ),
                            ),
                            InkWell(
                              onTap: () {
                                getImage();
                                img3 = basename(_image.path);
                                vimg3 = _image;
                              },
                              child: (vimg3 != null)
                                  ? Image.file(
                                      vimg3,
                                      fit: BoxFit.cover,
                                      height: 120,
                                      width: 120,
                                    )
                                  : Icon(
                                      Icons.insert_photo_rounded,
                                      size: 100,
                                    ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(60, 20, 60, 10),
                          child: SizedBox(
                            width: 500.0,
                            child: TextFormField(
                              controller: pdname,
                              decoration: InputDecoration(
                                hintText: 'ชื่อสินค้า',
                                hintStyle: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'กรุณาใส่ชื่อสินค้า';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Container(
                            decoration: BoxDecoration(border: Border.all()),
                            child: DropdownButton(
                              hint: Text("ประเภทสินค้า",
                                  style: TextStyle(color: Colors.black)),
                              value: select,
                              items: ["นักเรียน", "อื่นๆ"]
                                  .map((value) => DropdownMenuItem(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 6),
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(60, 0, 60, 10),
                          child: SizedBox(
                            width: 500.0,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: pdsizeS,
                              decoration: InputDecoration(
                                hintText: 'ไซต์ S ราคา/บาท',
                                hintStyle: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'กรุณาใส่ราคาสินค้า';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(60, 0, 60, 10),
                          child: SizedBox(
                            width: 500.0,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: pdsizeM,
                              decoration: InputDecoration(
                                hintText: 'ไซต์ M ราคา/บาท',
                                hintStyle: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'กรุณาใส่ราคาสินค้า';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(60, 0, 60, 10),
                          child: SizedBox(
                            width: 500.0,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: pdsizeL,
                              decoration: InputDecoration(
                                hintText: 'ไซต์ L ราคา/บาท',
                                hintStyle: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'กรุณาใส่ราคาสินค้า';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(60, 0, 60, 10),
                          child: SizedBox(
                            width: 500.0,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: pdsizeXL,
                              decoration: InputDecoration(
                                hintText: 'ไซต์ XL ราคา/บาท',
                                hintStyle: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'กรุณาใส่ราคาสินค้า';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: const Color(0xff0177ff))),
                                primary: Colors.red),
                            child: Text(
                              'เพิ่ม',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              if (_formkey.currentState.validate() &&
                                  select != null &&
                                  vimg1 != null &&
                                  vimg2 != null &&
                                  vimg3 != null) {
                                createProduct();
                                setState(() {
                                  select = null;
                                  pdname.clear();
                                  pdsizeL.clear();
                                  pdsizeM.clear();
                                  pdsizeS.clear();
                                  pdsizeXL.clear();
                                  img1 = null;
                                  img2 = null;
                                  img3 = null;
                                  vimg1 = null;
                                  vimg2 = null;
                                  vimg3 = null;
                                });
                                showSimpleSnackbar(
                                    "เพิ่มสินค้าสำเร็จ", context);
                              }
                            })
                      ],
                    ),
                  ),
                )
              : Container(
                  child: ListView.builder(
                      itemCount: product.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              isThreeLine: true,
                              title: Text("ชื่อสินค้า " + product[index].name),
                              subtitle: Text(
                                "รหัสสินค้า " +
                                    product[index].id +
                                    "\nสถานะสินค้า " +
                                    product[index].status,
                                maxLines: 2,
                              ),
                              trailing: CustomSwitch(
                                value: product[index].swicth,
                                activeColor: Colors.orange,
                                onChanged: (value) {
                                  if (product[index].swicth) {
                                    storage
                                        .updateStatusProduct(
                                            product[index].id, "not ready")
                                        .whenComplete(() {
                                      setState(() {
                                        product[index].swicth = false;
                                        product[index].status = "ไม่พร้อมใชงาน";
                                      });
                                      showSimpleSnackbar(
                                          "เปลี่ยนสถานะสินค้า " +
                                              product[index].name +
                                              " เป็นไม่พร้อมใช้งานแล้ว",
                                          context);
                                    });
                                  } else {
                                    storage
                                        .updateStatusProduct(
                                            product[index].id, "ready")
                                        .whenComplete(() {
                                      setState(() {
                                        product[index].swicth = true;
                                        product[index].status = "พร้อมใชงาน";
                                      });
                                      showSimpleSnackbar(
                                          "เปลี่ยนสถานะสินค้า " +
                                              product[index].name +
                                              " เป็นพร้อมใช้งานแล้ว",
                                          context);
                                    });
                                  }
                                },
                              ),
                            ),
                            Divider()
                          ],
                        );
                      }),
                ),
        ));
  }
}
