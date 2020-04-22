import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutterdemo/entities/contact.dart';
import 'package:flutterdemo/framework/application.dart';
import 'package:flutterdemo/framework/request.dart';
import 'package:intl/intl.dart';

class ContactFormPage extends StatefulWidget {
  final String operate;
  final int id;

  ContactFormPage({this.operate, this.id});

  @override
  State<StatefulWidget> createState() {
    return ContactState(operate: operate, id: id);
  }
}

class ContactState extends State<ContactFormPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final String operate;
  final int id;
  final Contact contact;
  final Map<String, TextEditingController> controllerMapping = {};

  ContactState({this.operate, this.id, this.contact});

  @override
  void initState() {
    super.initState();
    registerController('name');
    registerController('phone');
    registerController('lastContactDate');
    registerController('birthday');
    registerController('description');
  }

  @override
  didChangeDependencies() async {
    super.didChangeDependencies();
    if (this.operate == 'edit') {
      await getContactDetail();
    }
  }

  getContactDetail() async {
    Map detail = await request('/api/contact/detail', data: {'id': id});
    updateValues(detail);
  }

  _validateAndSubmit() async {
    if (_formKey.currentState.saveAndValidate()) {
      _formKey.currentState.save();
      Map value = _formKey.currentState.value;
      value['birthday'] = value['birthday'].toString() ?? null;
      value['lastContactDate'] = value['lastContactDate'].toString() ?? null;
      if (operate == 'edit') {
        value['id'] = id;
        var result = await request('/api/contact/update', data: value);
        if (result != null) {
          Application.router.pop(context);
        }
      } else {
        Map result = await request('/api/contact/add', data: value);
        if (result != null) {
          Application.router.pop(context);
        }
      }
    }
  }

  registerController(fieldName) {
    controllerMapping[fieldName] = TextEditingController();
  }

  getController(String fieldName) {
    return controllerMapping[fieldName];
  }

  updateValues(Map values) {
    values.forEach((key, value) {
      var controller = controllerMapping[key];
      if (controller != null) {
        controller.text = values[key];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(operate == 'edit' ? '编辑联系人' : '新增联系人'),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: _validateAndSubmit,
              child: Text('保存'),
            )
          ],
        ),
        body: Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: FormBuilder(
                key: _formKey,
                autovalidate: true,
                child: Column(
                  children: <Widget>[
                    FormBuilderTextField(
                      attribute: 'name',
                      controller: getController('name'),
                      decoration: InputDecoration(labelText: "姓名"),
                      validators: [
                        FormBuilderValidators.required(errorText: '名字还是填一下吧')
                      ],
                    ),
                    FormBuilderTextField(
                      attribute: 'phone',
                      controller: getController('phone'),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(labelText: "电话"),
                    ),
                    FormBuilderDateTimePicker(
                      attribute: "lastContactDate",
                      controller: getController('lastContactDate'),
                      inputType: InputType.date,
                      format: DateFormat("yyyy-MM-dd"),
                      decoration: InputDecoration(labelText: "最后联系日期"),
                    ),
                    FormBuilderDateTimePicker(
                      attribute: "birthday",
                      inputType: InputType.date,
                      controller: getController('birthday'),
                      format: DateFormat("yyyy-MM-dd"),
                      decoration: InputDecoration(labelText: "生日"),
                    ),
                    FormBuilderDropdown(
                        attribute: "gender",
                        decoration: InputDecoration(labelText: "性别"),
                        hint: Text('请选择性别'),
                        items: [
                          DropdownMenuItem(value: 0, child: Text("男")),
                          DropdownMenuItem(value: 1, child: Text("女"))
                        ]),
                    FormBuilderTextField(
                      attribute: 'description',
                      controller: getController('description'),
                      decoration: InputDecoration(labelText: "备注"),
                      maxLines: 5,
                      minLines: 3,
                    )
                  ],
                ),
              ),
            )));
  }
}
