import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pukjangg_adminn/Screen/AddSkinUser.dart';
import 'package:pukjangg_adminn/Screen/SelectSkin.dart';
import 'package:pukjangg_adminn/model/Skin.dart';

class ListSkins extends StatefulWidget {
  @override
  _ListSkinsState createState() => _ListSkinsState();
}

class _ListSkinsState extends State<ListSkins> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List<Skins> skinall = [];
  List<Skins> skindo = [];
  int select = 0;
  @override
  void initState() {
    super.initState();
    setList();
  }

  void setList() {
    databaseReference.child("Skins").once().then((DataSnapshot dataSnapshot) {
      skinall.clear();
      skindo.clear();
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;

      for (var key in keys) {
        if (values[key]['status'].toString() == "รอการตอบกลับจากทางร้าน") {
          Skins skin = new Skins(
              values[key]['detail'],
              values[key]['id'],
              values[key]['img'],
              values[key]['name'],
              values[key]['type'],
              values[key]['userid'],
              values[key]['status'],
              values[key]['price'].toString());
          setState(() {
            skinall.add(skin);
          });
        }
        if (values[key]['status'].toString() == "ชำระเงินแล้ว") {
          Skins skin = new Skins(
              values[key]['detail'],
              values[key]['id'],
              values[key]['img'],
              values[key]['name'],
              values[key]['type'],
              values[key]['userid'],
              values[key]['status'],
              values[key]['price'].toString());
          setState(() {
            skindo.add(skin);
          });
        }
      }
    });
  }

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
            title: Text("รายการเสนอลายปัก"),
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
                  icon: Icon(Icons.edit), label: "รายการลายปัก"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt), label: "รายการเพิ่มลายปัก"),
            ],
          ),
          body: select == 0
              ? Container(
                  child: (skinall.length == 0)
                      ? Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("ไม่มีรายการ"),
                            ],
                          ),
                        )
                      : Container(
                          child: ListView.builder(
                            itemCount: skinall.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SelectSkin(
                                                    detail:
                                                        skinall[index].detail,
                                                    id: skinall[index].id,
                                                    img: skinall[index].img,
                                                    name: skinall[index].name,
                                                    type: skinall[index].type,
                                                    userid:
                                                        skinall[index].userid,
                                                  ))).then((value) {
                                        setState(() {
                                          setList();
                                        });
                                      });
                                    },
                                    child: ListTile(
                                      title: Text("ชื่อลายปัก " +
                                          skinall[index].name.toString()),
                                      subtitle: Text("รหัสลูกค้า " +
                                          skinall[index].id.toString()),
                                    ),
                                  ),
                                  Divider(color: Colors.black)
                                ],
                              );
                            },
                          ),
                        ),
                )
              : Container(
                  child: (skindo.length == 0)
                      ? Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("ไม่มีรายการ"),
                            ],
                          ),
                        )
                      : Container(
                          child: ListView.builder(
                            itemCount: skindo.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddSkinUser(
                                                  id: skindo[index].id,
                                                  userid: skindo[index].userid,
                                                  name: skindo[index].name,
                                                  price: skindo[index]
                                                      .price))).then((value) {
                                        setState(() {
                                          setList();
                                        });
                                      });
                                    },
                                    child: ListTile(
                                      title: Text("ชื่อลายปัก " +
                                          skindo[index].name.toString()),
                                      subtitle: Text("รหัสลูกค้า " +
                                          skindo[index].id.toString()),
                                    ),
                                  ),
                                  Divider(color: Colors.black)
                                ],
                              );
                            },
                          ),
                        ),
                )),
    );
  }
}
