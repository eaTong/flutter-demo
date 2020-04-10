import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutterdemo/framework/application.dart';
import 'package:flutterdemo/framework/request.dart';
import 'package:intl/intl.dart';

class ContactFormPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<ContactFormPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  String name;
  String telephone;
  int gender;
  String description;
  DateTime birthday;
  String avatar;

  _validateAndSubmit() async {
    if (_formKey.currentState.saveAndValidate()) {
      _formKey.currentState.save();
      Map value = _formKey.currentState.value;
      value['birthday'] = value['birthday'].toString();
      value['lastContactTime'] = value['lastContactTime'].toString();
      Map result =
          await request('/api/contact/add', data:value);
      if (result != null) {
        Application.router.pop(context);
      }
    } else {
      _formKey.currentState.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('新增联系人'),
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
                      decoration: InputDecoration(labelText: "姓名"),
                      validators: [
                        FormBuilderValidators.required(errorText: '名字还是填一下吧')
                      ],
                    ),
                    FormBuilderTextField(
                      attribute: 'telephone',
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(labelText: "电话"),
                    ),
                    FormBuilderDateTimePicker(
                      attribute: "lastContactTime",
                      inputType: InputType.date,
                      format: DateFormat("yyyy-MM-dd"),
                      decoration: InputDecoration(labelText: "最后联系日期"),
                    ),
                    FormBuilderDateTimePicker(
                      attribute: "birthday",
                      inputType: InputType.date,
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
                      attribute: 'remark',
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
