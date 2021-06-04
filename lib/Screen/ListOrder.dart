import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pukjangg_adminn/Screen/SelectOrder.dart';
import 'package:pukjangg_adminn/model/Cart.dart';

class ListOrder extends StatefulWidget {
  @override
  _ListOrderState createState() => _ListOrderState();
}

class _ListOrderState extends State<ListOrder> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List<Cart> block = [];
  List<Cart> puk = [];
  List<Cart> send = [];
  int select = 0;
  @override
  void initState() {
    super.initState();

    setList();
  }

  void setList() {
    databaseReference.child("Carts").once().then((DataSnapshot dataSnapshot) {
      block.clear();
      puk.clear();
      send.clear();
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;

      for (var key in keys) {
        if (values[key]["status"] == "payment") {
          Cart cart = new Cart(
              values[key]["id"],
              values[key]["status"],
              values[key]["userid"],
              values[key]["countorder"].toString(),
              values[key]["address"],
              values[key]["name"],
              values[key]["phone"],
              values[key]["sender"]);
          setState(() {
            block.add(cart);
          });
        }
        if (values[key]["status"] == "block") {
          Cart cart = new Cart(
              values[key]["id"],
              values[key]["status"],
              values[key]["userid"],
              values[key]["countorder"].toString(),
              values[key]["address"],
              values[key]["name"],
              values[key]["phone"],
              values[key]["sender"]);
          setState(() {
            puk.add(cart);
          });
        }
        if (values[key]["status"] == "puk") {
          Cart cart = new Cart(
              values[key]["id"],
              values[key]["status"],
              values[key]["userid"],
              values[key]["countorder"].toString(),
              values[key]["address"],
              values[key]["name"],
              values[key]["phone"],
              values[key]["sender"]);
          setState(() {
            send.add(cart);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = 'รายการทำงาน';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
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
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: select,
            onTap: (index) {
              setState(() {
                select = index;
              });
              setList();
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.edit), label: "รายการทำบล็อค"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt), label: "รายการปัก"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.local_shipping_outlined),
                  label: "รายการจัดส่ง"),
            ],
          ),
          body: Container(
              child: select == 0
                  ? Container(
                      child: block.length == 0
                          ? Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("ไม่มีข้อมูล"),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: block.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SelectOrder(
                                                      id: block[index].id,
                                                      status:
                                                          block[index].status,
                                                      userid:
                                                          block[index].userid,
                                                      countOrder: block[index]
                                                          .countOrder,
                                                    ))).then((value) {
                                          setState(() {
                                            setList();
                                          });
                                        });
                                      },
                                      child: ListTile(
                                        title: Text("รหัสรายการสั่ง " +
                                            block[index].id.toString()),
                                        subtitle: Text("จำนวนออร์เดอร์ " +
                                            block[index].countOrder.toString()),
                                      ),
                                    ),
                                    Divider(color: Colors.black)
                                  ],
                                );
                              },
                            ),
                    )
                  : select == 1
                      ? Container(
                          child: puk.length == 0
                              ? Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text("ไม่มีข้อมูล"),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: puk.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SelectOrder(
                                                      id: puk[index].id,
                                                      status: puk[index].status,
                                                      userid: puk[index].userid,
                                                      countOrder:
                                                          puk[index].countOrder,
                                                    ))).then((value) {
                                          setState(() {
                                            setList();
                                          });
                                        });
                                      },
                                      child: ListTile(
                                        title: Text("รหัสรายการสั่ง " +
                                            puk[index].id.toString()),
                                        subtitle: Text("จำนวนออร์เดอร์ " +
                                            puk[index].countOrder.toString()),
                                      ),
                                    );
                                  },
                                ),
                        )
                      : select == 2
                          ? Container(
                              child: send.length == 0
                                  ? Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text("ไม่มีข้อมูล"),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: send.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SelectOrder(
                                                          id: send[index].id,
                                                          status: send[index]
                                                              .status,
                                                          userid: send[index]
                                                              .userid,
                                                          countOrder:
                                                              send[index]
                                                                  .countOrder,
                                                        ))).then((value) {
                                              setState(() {
                                                setList();
                                              });
                                            });
                                          },
                                          child: ListTile(
                                            title: Text("รหัสรายการสั่ง " +
                                                send[index].id.toString()),
                                            subtitle: Text("จำนวนออร์เดอร์ " +
                                                send[index]
                                                    .countOrder
                                                    .toString()),
                                          ),
                                        );
                                      },
                                    ),
                            )
                          : Container())),
    );
  }
}
