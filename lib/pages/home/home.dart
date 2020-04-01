import 'package:flutter/material.dart';
import 'package:flutterdemo/framework/application.dart';
import 'package:flutterdemo/framework/request.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomePage> {
  List<Map> contractList = [];

  @override
  initState() {
    super.initState();
    getContacts();
  }

  getContacts() async {
    Map contracts = await request('/api/contact/get');
    if (contracts != null) {
      List<Map> resolvedList = [];
      print(contracts['list']);
      List dataList = contracts['list'];
      dataList.forEach((value) {
        print(value);
        Map contact = value;
        resolvedList.add(contact);
      });
      setState(() {
        contractList = resolvedList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ListView.separated(
              itemCount: contractList.length,
              separatorBuilder: (context, index) => Divider(height: .0),
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    title: Text("${index + 1}~${contractList[index]['name']}"));
              })),
    );
  }
}
