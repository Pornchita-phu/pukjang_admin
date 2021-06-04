import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pukjangg_adminn/model/Logo.dart';
import 'package:pukjangg_adminn/model/Order.dart';
import 'package:pukjangg_adminn/service/Storage.dart';

class SelectOrder extends StatefulWidget {
  final String id, userid, status, countOrder;
  SelectOrder({this.id, this.status, this.userid, this.countOrder});
  @override
  _SelectOrderState createState() => _SelectOrderState();
}

class _SelectOrderState extends State<SelectOrder> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List<Order> orderListall = [];
  List<Order> orderList = [];
  List<Logo> logoListall = [];
  List<Logo> logoList = [];
  String name, address, phone, sender;
  String title;
  Storage storage = new Storage();

  @override
  void initState() {
    super.initState();
    getCart();
    setLogoListall();
    setOrderList();
    if (widget.status == "payment") {
      setState(() {
        title = "รายการทำบล็อค รหัส " + widget.id;
      });
    }
    if (widget.status == "block") {
      setState(() {
        title = "รายการปัก รหัส " + widget.id;
      });
    }
    if (widget.status == "puk") {
      setState(() {
        title = "รายการจัดส่ง รหัส " + widget.id;
      });
    }
  }

  void getCart() {
    databaseReference
        .child("Carts")
        .child(widget.id)
        .child("name")
        .onValue
        .listen((event) {
      setState(() {
        name = event.snapshot.value.toString();
      });
    });
    databaseReference
        .child("Carts")
        .child(widget.id)
        .child("address")
        .onValue
        .listen((event) {
      setState(() {
        address = event.snapshot.value.toString();
      });
    });
    databaseReference
        .child("Carts")
        .child(widget.id)
        .child("phone")
        .onValue
        .listen((event) {
      setState(() {
        phone = event.snapshot.value.toString();
      });
    });
    databaseReference
        .child("Carts")
        .child(widget.id)
        .child("sender")
        .onValue
        .listen((event) {
      setState(() {
        sender = event.snapshot.value.toString();
      });
    });
  }

  void setOrderList() {
    databaseReference
        .child("Carts")
        .child(widget.id)
        .child("Orders")
        .once()
        .then((DataSnapshot dataSnapshot) {
      orderList.clear();
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;

      for (var key in keys) {
        if (values[key]["logo"] == "yes") {
          Order order = new Order(
              values[key]["count"].toString(),
              values[key]["detail"].toString(),
              values[key]["firstname"].toString(),
              values[key]["firstnameEN"].toString(),
              values[key]["id"].toString(),
              values[key]["lastname"].toString(),
              values[key]["lastnaemEN"].toString(),
              values[key]["logo"].toString(),
              values[key]["logoprice"].toString(),
              values[key]["name"].toString(),
              values[key]["nickname"].toString(),
              values[key]["productid"].toString(),
              values[key]["school"].toString(),
              values[key]["shirtprice"].toString(),
              values[key]["size"].toString(),
              values[key]["studentid"].toString(),
              values[key]["blockid"].toString());
          setState(() {
            orderList.add(order);
          });
        }
        Order orderall = new Order(
            values[key]["count"].toString(),
            values[key]["detail"].toString(),
            values[key]["firstname"].toString(),
            values[key]["firstnameEN"].toString(),
            values[key]["id"].toString(),
            values[key]["lastname"].toString(),
            values[key]["lastnaemEN"].toString(),
            values[key]["logo"].toString(),
            values[key]["logoprice"].toString(),
            values[key]["name"].toString(),
            values[key]["nickname"].toString(),
            values[key]["productid"].toString(),
            values[key]["school"].toString(),
            values[key]["shirtprice"].toString(),
            values[key]["size"].toString(),
            values[key]["studentid"].toString(),
            values[key]["blockid"].toString());
        setState(() {
          orderListall.add(orderall);
        });
      }
      setLogoList();
    });
  }

  void setLogoListall() {
    databaseReference.child("Logo").once().then((DataSnapshot dataSnapshot) {
      logoListall.clear();
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;

      for (var key in keys) {
        Logo logo = new Logo(
            values[key]["detail"].toString(),
            values[key]["firstname"].toString(),
            values[key]["firstnameEN"].toString(),
            values[key]["lastname"].toString(),
            values[key]["lastnameEN"].toString(),
            values[key]["name"].toString(),
            values[key]["nickname"].toString(),
            double.parse(values[key]["price"].toString()),
            values[key]["studentid"].toString(),
            values[key]["type"].toString(),
            values[key]["url"].toString(),
            values[key]["userid"].toString(),
            values[key]["id"].toString());
        setState(() {
          logoListall.add(logo);
        });
      }
    });
  }

  void setLogoList() {
    logoList.clear();
    for (int x = 0; x < orderList.length; x++) {
      for (int i = 0; i < logoListall.length; i++) {
        if (logoListall[i].name == orderList[x].school) {
          Logo logo = new Logo(
            logoListall[i].detail.toString(),
            logoListall[i].firstname.toString(),
            logoListall[i].firstnameEN.toString(),
            logoListall[i].lastname.toString(),
            logoListall[i].lastnameEN.toString(),
            logoListall[i].name.toString(),
            logoListall[i].nickname.toString(),
            double.parse(logoListall[i].price.toString()),
            logoListall[i].studentid.toString(),
            logoListall[i].type.toString(),
            logoListall[i].url.toString(),
            logoListall[i].userid.toString(),
            logoListall[i].id.toString(),
          );
          setState(() {
            logoList.add(logo);
          });
        }
      }
    }
  }

  updateData() async {
    for (int i = 0; i < orderList.length; i++) {
      storage.updateBlockid(
          widget.id, orderList[i].id, widget.id + "_" + (i + 1).toString());
    }
    storage.updateCartStatus(widget.id, "block");
    Navigator.pop(context);
  }

  final _formkey = GlobalKey<FormState>();
  TextEditingController sendid = new TextEditingController();
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
            title: Text(title),
          ),
          body: widget.status == "payment"
              ? ListView(children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: orderList.length,
                    itemBuilder: (context, index) {
                      return Container(
                          padding: EdgeInsets.fromLTRB(8, 12, 8, 0),
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "ออร์เดอร์ที่ " + (index + 1).toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "ชื่อไฟล์ ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(widget.id + "_" + (index + 1).toString(),
                                    style: TextStyle(fontSize: 16))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("ชื่อลาย ",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Flexible(
                                    child: Text(logoList[index].name,
                                        maxLines: 2,
                                        style: TextStyle(fontSize: 16)))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("รายละเอียด ",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Flexible(
                                    child: Text(logoList[index].detail,
                                        maxLines: 3,
                                        style: TextStyle(fontSize: 16))),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("รูปภาพ ",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                    child: logoList[index].url == "no"
                                        ? Text("ไม่มี",
                                            style: TextStyle(
                                              fontSize: 16,
                                            ))
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.network(
                                              logoList[index].url,
                                              height: 150,
                                              width: 150,
                                            ),
                                          )),
                              ],
                            ),
                            Container(
                              child: logoList[index].firstname == "no"
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text("ชื่อจริง ",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        Text(orderList[index].firstname,
                                            style: TextStyle(fontSize: 16))
                                      ],
                                    ),
                            ),
                            Container(
                              child: logoList[index].lastname == "no"
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text("นามสกุล ",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        Text(orderList[index].lastname,
                                            style: TextStyle(fontSize: 16))
                                      ],
                                    ),
                            ),
                            Container(
                              child: logoList[index].firstnameEN == "no"
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text("ชื่อจริง(อังกฤษ) ",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        Text(orderList[index].firstnameEN,
                                            style: TextStyle(fontSize: 16))
                                      ],
                                    ),
                            ),
                            Container(
                              child: logoList[index].lastnameEN == "no"
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text("นามสกุล(อังกฤษ) ",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        Text(orderList[index].lastnameEN,
                                            style: TextStyle(fontSize: 16))
                                      ],
                                    ),
                            ),
                            Container(
                              child: logoList[index].nickname == "no"
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text("ชื่อเล่น ",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        Text(orderList[index].nickname,
                                            style: TextStyle(fontSize: 16))
                                      ],
                                    ),
                            ),
                            Container(
                              child: logoList[index].studentid == "no"
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text("รหัสนักเรียน ",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        Text(orderList[index].studentid,
                                            style: TextStyle(fontSize: 16))
                                      ],
                                    ),
                            ),
                            Divider(
                              color: Colors.black,
                            )
                          ]));
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 12),
                    height: 50,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Colors.blueAccent),
                      onPressed: () {
                        updateData();
                      },
                      child: Text(
                        "ทำรายการนี้แล้ว",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  )
                ])
              : widget.status == "block"
                  ? ListView(children: [
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: orderList.length,
                        itemBuilder: (context, index) {
                          return Container(
                              padding: EdgeInsets.fromLTRB(8, 12, 8, 0),
                              child: Column(children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "ออร์เดอร์ที่ " + (index + 1).toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                (orderList[index].name == null ||
                                        orderList[index].name == "")
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "เสื้อที่ปัก ",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("เป็นเสื้อที่ลูกค้าส่งมา",
                                              style: TextStyle(fontSize: 16))
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "ชื่อเสื้อที่ปัก ",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(orderList[index].name,
                                              style: TextStyle(fontSize: 16))
                                        ],
                                      ),
                                (orderList[index].name == null ||
                                        orderList[index].name == "")
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "รายละเอียดเสื้อของลูกค้า ",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(orderList[index].detail,
                                              style: TextStyle(fontSize: 16))
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "ไซต์เสื้อ ",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(orderList[index].size,
                                              style: TextStyle(fontSize: 16))
                                        ],
                                      ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "จำนวน ",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        orderList[index].count.toString() +
                                            " ตัว",
                                        style: TextStyle(fontSize: 16))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "ชื่อไฟล์ลายปัก ",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        widget.id +
                                            "_" +
                                            (index + 1).toString(),
                                        style: TextStyle(fontSize: 16))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("ชื่อลาย ",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    Flexible(
                                        child: Text(logoList[index].name,
                                            maxLines: 2,
                                            style: TextStyle(fontSize: 16)))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("รายละเอียด ",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    Flexible(
                                        child: Text(logoList[index].detail,
                                            maxLines: 3,
                                            style: TextStyle(fontSize: 16))),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("รูปภาพ ",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    Container(
                                        child: logoList[index].url == "no"
                                            ? Text("ไม่มี",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ))
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.network(
                                                  logoList[index].url,
                                                  height: 150,
                                                  width: 150,
                                                ),
                                              )),
                                  ],
                                ),
                                Container(
                                  child: logoList[index].firstname == "no"
                                      ? Container()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text("ชื่อจริง ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(orderList[index].firstname,
                                                style: TextStyle(fontSize: 16))
                                          ],
                                        ),
                                ),
                                Container(
                                  child: logoList[index].lastname == "no"
                                      ? Container()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text("นามสกุล ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(orderList[index].lastname,
                                                style: TextStyle(fontSize: 16))
                                          ],
                                        ),
                                ),
                                Container(
                                  child: logoList[index].firstnameEN == "no"
                                      ? Container()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text("ชื่อจริง(อังกฤษ) ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(orderList[index].firstnameEN,
                                                style: TextStyle(fontSize: 16))
                                          ],
                                        ),
                                ),
                                Container(
                                  child: logoList[index].lastnameEN == "no"
                                      ? Container()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text("นามสกุล(อังกฤษ) ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(orderList[index].lastnameEN,
                                                style: TextStyle(fontSize: 16))
                                          ],
                                        ),
                                ),
                                Container(
                                  child: logoList[index].nickname == "no"
                                      ? Container()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text("ชื่อเล่น ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(orderList[index].nickname,
                                                style: TextStyle(fontSize: 16))
                                          ],
                                        ),
                                ),
                                Container(
                                  child: logoList[index].studentid == "no"
                                      ? Container()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text("รหัสนักเรียน ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(orderList[index].studentid,
                                                style: TextStyle(fontSize: 16))
                                          ],
                                        ),
                                ),
                                Divider(
                                  color: Colors.black,
                                )
                              ]));
                        },
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 12),
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blueAccent),
                          onPressed: () {
                            storage.updateCartStatus(widget.id, "puk");
                            Navigator.pop(context);
                          },
                          child: Text(
                            "ทำรายการนี้แล้ว",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ])
                  : ListView(children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 12, 8, 0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "ชื่อในการจัดส่ง ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(name, style: TextStyle(fontSize: 16))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "ที่อยู่ในการจัดส่ง ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Flexible(
                                    child: Text(address,
                                        style: TextStyle(fontSize: 16)))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "เบอร์โทร ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(phone, style: TextStyle(fontSize: 16))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "วิธีการจัดส่ง ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(sender, style: TextStyle(fontSize: 16))
                              ],
                            ),
                            Divider(
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: orderListall.length,
                        itemBuilder: (context, index) {
                          return Container(
                              padding: EdgeInsets.fromLTRB(8, 12, 8, 0),
                              child: Column(children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "ออร์เดอร์ที่ " + (index + 1).toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                (orderListall[index].name == null ||
                                        orderListall[index].name == "")
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "ชื่อเสื้อที่ปัก ",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("เป็นเสื้อที่ลูกค้าส่งมา",
                                              style: TextStyle(fontSize: 16))
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "ชื่อเสื้อ ",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(orderListall[index].name,
                                              style: TextStyle(fontSize: 16))
                                        ],
                                      ),
                                (orderListall[index].name == null ||
                                        orderListall[index].name == "")
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "รายละเอียดเสื้อของลูกค้า ",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(orderListall[index].detail,
                                              style: TextStyle(fontSize: 16))
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "ไซต์เสื้อ ",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(orderListall[index].size,
                                              style: TextStyle(fontSize: 16))
                                        ],
                                      ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "จำนวน ",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        orderListall[index].count.toString() +
                                            " ตัว",
                                        style: TextStyle(fontSize: 16))
                                  ],
                                ),
                                (orderListall[index].blockid == null ||
                                        orderListall[index].blockid == "null")
                                    ? Container()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "ชื่อลายปัก ",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                              orderListall[index]
                                                  .school
                                                  .toString(),
                                              style: TextStyle(fontSize: 16))
                                        ],
                                      ),
                                Divider(
                                  color: Colors.black,
                                )
                              ]));
                        },
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(8, 12, 8, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "เลขพัสดุ",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 12),
                              width: 300,
                              child: Form(
                                key: _formkey,
                                child: TextFormField(
                                  controller: sendid,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'กรุณาใส่เลขพัสดุ';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 12),
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blueAccent),
                          onPressed: () {
                            if (_formkey.currentState.validate()) {
                              storage.updateCartStatus(widget.id, "send");
                              storage.updateSendid(
                                  widget.id, sendid.value.text);
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            "ทำรายการนี้แล้ว",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ])),
    );
  }
}
