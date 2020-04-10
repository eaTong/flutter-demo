import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterdemo/framework/application.dart';
import 'package:flutterdemo/framework/request.dart';
import 'package:flutterdemo/framework/toast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomePage> {
  List<Map> contractList = [];
  int pageIndex = 0;
  int total = 0;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  initState() {
    super.initState();
    getContacts();
  }

  navigateToContact() {
    Application.router.navigateTo(context, '/contact/form/add');
  }

  deleteContact(Map contact) {
    showConfirm("是否确认删除该联系人?", () async {
      var result = await request('/api/contact/delete', data: {
        "ids": [contact['id']]
      });
      print(result);
      if (result != null) {
        showToast('删除成功！');
        getContacts();
      }
    });
  }

  getContacts({int page = 0}) async {
    pageIndex = page;
    Map contracts =
        await request('/api/contact/get', data: {'pageIndex': page});
    if (contracts != null) {
      List<Map> resolvedList = page == 0 ? [] : contractList;
      List dataList = contracts['list'];
      total = contracts['total'];
      dataList.forEach((value) {
        Map contact = value;
        resolvedList.add(contact);
      });
      setState(() {
        contractList = resolvedList;
      });
    }
    _refreshController.refreshCompleted();
    _refreshController.loadComplete();
  }

  Widget buildList() {
    return ListView.separated(
        itemCount: contractList.length,
        separatorBuilder: (context, index) => Divider(height: .0),
        itemBuilder: (BuildContext context, int index) {
          Map contact = contractList[index];
          List<dynamic> tags = contact['tags'];
          return Slidable(
            key: Key(contact['id'].toString()),
            actionPane: SlidableStrechActionPane(),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: (Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        contact['name'] ?? '',
                        style: TextStyle(
                            color: contact['gender'] == 1
                                ? Colors.redAccent
                                : Colors.lightBlue),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                        child: Text(contact['phone'] ?? ''),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                        child: Text(contact['birthday'] ?? ''),
                      ),
                    ],
                  ),
                  Row(
                    children: tags
                        .map((var tag) => Container(
                              decoration: BoxDecoration(
                                color: Colors.greenAccent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                border: new Border.all(
                                    width: 1, color: Colors.greenAccent),
                              ),
                              margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                              padding: EdgeInsets.fromLTRB(4, 0, 4, 2),
                              child: Text(tag['name'],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            ))
                        .toList(),
                  ),
                  contact['description'] != null ? Text('222') : Offstage()
                ],
              )),
            ),
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: '编辑',
                color: Colors.black45,
                icon: Icons.edit,
                onTap: () {
                  print('edit');
                  Slidable.of(context);
                },
              ),
              IconSlideAction(
                caption: '删除',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () => deleteContact(contact),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToContact,
        child: Icon(Icons.add),
      ),
      body: Center(
          child: SmartRefresher(
              controller: _refreshController,
              enablePullUp: total > contractList.length,
              child: buildList(),
              header: WaterDropHeader(),
              onRefresh: getContacts,
              onLoading: () async => await getContacts(page: pageIndex + 1))),
    );
  }
}
