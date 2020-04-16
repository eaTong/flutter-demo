import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterdemo/framework/application.dart';
import 'package:flutterdemo/framework/request.dart';
import 'package:flutterdemo/framework/toast.dart';
import 'package:flutterdemo/stores/app_store.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomePage> {
  AppStore _appStore;
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

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _appStore = Provider.of<AppStore>(context);
  }

  navigateToContact({String operate = 'add', int id}) {
    Application.router.navigateTo(context, '/contact/form/$operate/$id');
  }

  deleteContact(Map contact) {
    showConfirm("是否确认删除该联系人?", () async {
      var result = await request('/api/contact/delete', data: {
        "ids": [contact['id']]
      });
      if (result != null) {
        showToast('删除成功！');
        getContacts();
      }
    });
  }

  getContacts({int page = 0}) async {
    print('aha....');
    print(_appStore.loginUser.toJson());
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
    ThemeData themeData = Theme.of(context);
    return ListView.separated(
        itemCount: contractList.length,
        separatorBuilder: (context, index) => Divider(height: .0),
        itemBuilder: (BuildContext context, int index) {
          Map contact = contractList[index];
          List<dynamic> tags = contact['tags'];
          List<Widget> actions = [
            IconSlideAction(
              caption: '编辑',
              color: Colors.black45,
              icon: Icons.edit,
              onTap: () =>
                  navigateToContact(operate: 'edit', id: contact['id']),
            ),
            IconSlideAction(
              caption: '删除',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => deleteContact(contact),
            )
          ];
          if (contact['phone'] != null) {
            actions.add(
              IconSlideAction(
                  caption: '电话',
                  color: Colors.lightBlue,
                  icon: Icons.phone,
                  onTap: () => launch('tel:${contact['phone']}')),
            );
          }
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
                              fontSize: 18,
                              color: contact['gender'] == 1
                                  ? themeData.errorColor
                                  : themeData.primaryColor),
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
                    contact['description'] != null
                        ? Row(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  contact['description'],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: Colors.black38),
                                ),
                              )
                            ],
                          )
                        : Offstage()
                  ],
                )),
              ),
              secondaryActions: actions);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToContact(operate: 'add'),
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
