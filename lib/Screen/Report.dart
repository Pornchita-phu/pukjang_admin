import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pukjangg_adminn/model/OrderReport.dart';

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  final formatCurrency = new NumberFormat("###,###.00");
  DateTime dateData;
  List<OrderReport> data = [];
  int totalOrder = 0;
  double totalPrice = 0.0;
  final databaseReference = FirebaseDatabase.instance.reference();
  final reference = FirebaseDatabase.instance.reference();
  int month;
  int year;
  String monthTH;
  @override
  void initState() {
    super.initState();
    month = DateTime.now().month;
    year = DateTime.now().year;
    setThai();
    setTime();
  }

  void setThai() {
    if (month == 1) {
      setState(() {
        monthTH = 'มกราคม';
      });
    } else if (month == 2) {
      setState(() {
        monthTH = 'กุมพาพันธ์';
      });
    } else if (month == 3) {
      setState(() {
        monthTH = 'มีนาคม';
      });
    } else if (month == 4) {
      setState(() {
        monthTH = 'เมษายน';
      });
    } else if (month == 5) {
      setState(() {
        monthTH = 'พฤษภาคม';
      });
    } else if (month == 6) {
      setState(() {
        monthTH = 'มิถุนายน';
      });
    } else if (month == 7) {
      setState(() {
        monthTH = 'กรกฎาคม';
      });
    } else if (month == 8) {
      setState(() {
        monthTH = 'สิงหาคม';
      });
    } else if (month == 9) {
      setState(() {
        monthTH = 'กันยายน';
      });
    } else if (month == 10) {
      setState(() {
        monthTH = 'ตุลาคม';
      });
    } else if (month == 11) {
      setState(() {
        monthTH = 'พฤษจิกายน';
      });
    } else if (month == 12) {
      setState(() {
        monthTH = 'ธันวาคม';
      });
    }
  }

  void setTime() async {
    await databaseReference
        .child("Carts")
        .once()
        .then((DataSnapshot dataSnapshot) {
      setState(() {
        totalOrder = 0;
        totalPrice = 0;
      });
      data.clear();
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;
      for (var key in keys) {
        if (values[key]["time"] != null && values[key]["price"] != null) {
          setState(() {
            dateData = dateFormat.parse(values[key]["time"].toString());
          });
          if (dateData.month == month && dateData.year == year) {
            OrderReport order = OrderReport(
              values[key]["id"],
              int.parse(values[key]["countorder"].toString()),
              double.parse(values[key]["price"].toString()),
            );
            setState(() {
              setOrder(values[key]["id"].toString(), order,
                  values[key]["sender"].toString());
              totalPrice += double.parse(values[key]["price"].toString());
              totalOrder++;
            });
          }
        }
        setState(() {
          dateData = null;
        });
      }
    });
  }

  setOrder(String id, OrderReport order, String sender) async {
    int count = 0;
    await reference
        .child("Carts")
        .child(id)
        .child("Orders")
        .once()
        .then((DataSnapshot dataSnapshot) {
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;
      data.add(order);
      for (var key in keys) {
        if ((values[key]["school"].toString() == "null" ||
                values[key]["school"].toString() == "" ||
                values[key]["school"].toString() == null ||
                values[key]["school"].toString() == "no") &&
            (values[key]["name"].toString() != "null" ||
                values[key]["name"].toString() != "no" ||
                values[key]["name"].toString() != "" ||
                values[key]["name"].toString() != null)) {
          double price = (double.parse(values[key]["logoprice"].toString()) +
                  double.parse(values[key]["shirtprice"].toString())) *
              int.parse(values[key]["count"].toString());
          OrderReport orderReport = new OrderReport(
              id, int.parse(values[key]["count"].toString()), price,
              orderName: values[key]["name"].toString());
          setState(() {
            count += int.parse(values[key]["count"].toString());
            data.add(orderReport);
          });
        } else if ((values[key]["school"].toString() != "null" ||
                values[key]["school"].toString() != "" ||
                values[key]["school"].toString() != null ||
                values[key]["school"].toString() != "no") &&
            (values[key]["name"].toString() == "null" ||
                values[key]["name"].toString() == "no" ||
                values[key]["name"].toString() == "" ||
                values[key]["name"].toString() == null)) {
          double price = (double.parse(values[key]["logoprice"].toString()) +
                  double.parse(values[key]["shirtprice"].toString())) *
              int.parse(values[key]["count"].toString());
          OrderReport orderReport = new OrderReport(
              id, int.parse(values[key]["count"].toString()), price,
              orderName: "ลายปัก " + values[key]["school"].toString());
          setState(() {
            count += int.parse(values[key]["count"].toString());
            data.add(orderReport);
          });
        } else {
          double price = (double.parse(values[key]["logoprice"].toString()) +
                  double.parse(values[key]["shirtprice"].toString())) *
              int.parse(values[key]["count"].toString());
          OrderReport orderReport = new OrderReport(
              id, int.parse(values[key]["count"].toString()), price,
              orderName: values[key]["name"].toString() + " + ลายปัก");
          setState(() {
            count += int.parse(values[key]["count"].toString());
            data.add(orderReport);
          });
        }
      }
      if (sender == "เคอรี่") {
        double senderPrice = 60.0 + ((count - 1) * 10);
        OrderReport orderReport =
            new OrderReport(id, 0, senderPrice, orderName: "จัดส่ง เคอรี่");
        setState(() {
          data.add(orderReport);
        });
      } else {
        double senderPrice = 30.0 + ((count - 1) * 10);
        OrderReport orderReport =
            new OrderReport(id, 0, senderPrice, orderName: "จัดส่ง ไปรษณีย์");
        setState(() {
          data.add(orderReport);
        });
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
          title: Text("รายงาน"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("สรุปยอดขาย",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 40,
                            icon: Icon(Icons.arrow_left),
                            onPressed: () {
                              if (month == 1) {
                                setState(() {
                                  month = 12;
                                  year = year - 1;
                                });
                              } else {
                                setState(() {
                                  month = month - 1;
                                });
                              }
                              setThai();
                              setTime();
                            },
                          ),
                          Text(
                            monthTH + "  " + (year + 543).toString(),
                            style: TextStyle(fontSize: 18),
                          ),
                          month != DateTime.now().month
                              ? IconButton(
                                  iconSize: 40,
                                  icon: Icon(Icons.arrow_right),
                                  onPressed: () {
                                    if (month == 12) {
                                      setState(() {
                                        month = 1;
                                        year = year + 1;
                                      });
                                    } else {
                                      setState(() {
                                        month = month + 1;
                                      });
                                    }
                                    setThai();
                                    setTime();
                                  },
                                )
                              : Container()
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: DataTable(
                        columnSpacing: 15,
                        columns: [
                          DataColumn(
                              label: Container(
                            width: 200,
                            child: Text(
                              'รหัสใบสั่งซื้อ/ชื่อสินค้า',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          )),
                          DataColumn(
                              label: Container(
                            width: 65,
                            child: Text('รายการ',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          )),
                          DataColumn(
                              label: Container(
                            width: 135,
                            child: Text(
                              'ราคา (฿)',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          )),
                        ],
                        rows: List<DataRow>.generate(
                            data.length + 1,
                            (index) => (index + 1) != (data.length + 1)
                                ? data[index].orderName == null
                                    ? DataRow(
                                        cells: [
                                            DataCell(Container(
                                              width: 200,
                                              child: Text(
                                                data[index].id,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )),
                                            DataCell(
                                              Container(
                                                width: 65,
                                                child: Text(
                                                  data[index].order.toString(),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            DataCell(Container(
                                              width: 135,
                                              child: Text(
                                                formatCurrency
                                                    .format(data[index].price),
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )),
                                          ],
                                        color: MaterialStateColor.resolveWith(
                                            (states) {
                                          return Colors.orangeAccent[100];
                                        }))
                                    : DataRow(cells: [
                                        DataCell(Container(
                                          width: 200,
                                          child: Text(
                                            data[index].orderName,
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        )),
                                        data[index].order != 0
                                            ? DataCell(Container(
                                                width: 65,
                                                child: Text(
                                                    data[index]
                                                        .order
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                    )),
                                              ))
                                            : DataCell(Container(
                                                width: 65,
                                              )),
                                        DataCell(Container(
                                          width: 135,
                                          child: Text(
                                            formatCurrency
                                                .format(data[index].price),
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        )),
                                      ])
                                : DataRow(cells: [
                                    DataCell(Container(
                                      width: 200,
                                      child: Text(
                                        "รวม " +
                                            totalOrder.toString() +
                                            " รายการ",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                    DataCell(Container(
                                      width: 65,
                                    )),
                                    DataCell(Container(
                                      width: 135,
                                      child: Text(
                                        formatCurrency.format(totalPrice),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                  ])),
                      ),
                    )
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
