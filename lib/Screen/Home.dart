import 'package:flutter/material.dart';
import 'package:pukjangg_adminn/Screen/AddProduct.dart';
import 'package:pukjangg_adminn/Screen/AddSkin.dart';

import 'package:pukjangg_adminn/Screen/ListOrder.dart';
import 'package:pukjangg_adminn/Screen/ListSkins.dart';
import 'package:pukjangg_adminn/Screen/Report.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orangeAccent,
            title: Text('LinePuk'),
          ),
          body: Container(
            color: Colors.blueGrey[900],
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ListOrder()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Image(
                          image: AssetImage('assets/image/list.png'),
                          height: 80,
                          width: 80,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                          child: Text(
                            "ลิสต์ทำบล็อค",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddProduct()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Image(
                          image: AssetImage('assets/image/update.png'),
                          height: 80,
                          width: 80,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                          child: Text(
                            "อัปเดตสินค้า",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddSkin()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Image(
                          image: AssetImage('assets/image/add.png'),
                          height: 80,
                          width: 80,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                          child: Text(
                            "อัพเดตลายปัก",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ListSkins()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Image(
                          image: AssetImage('assets/image/show.png'),
                          height: 80,
                          width: 80,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                          child: Text(
                            "แสดงรายสั่งปัก",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Report()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Image(
                          image: AssetImage('assets/image/report.png'),
                          height: 80,
                          width: 80,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                          child: Text(
                            "แสดงรีพอร์ท",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
