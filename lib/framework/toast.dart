import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

void showConfirm(String content, Function onConfirm, {String title}) {
  BotToast.showWidget(toastBuilder: (cancelFunc) {
    return Container(
        color: Colors.black38,
        child: Center(
          child: AlertDialog(
            title: title == null ? null : Text(title),
            content: Text(content),
            actions: <Widget>[
              FlatButton(
                onPressed: cancelFunc,
                child: Text(
                  "取消",
                  style: TextStyle(color: Color(0xff707070)),
                ),
              ),
              FlatButton(
                onPressed: () {
                  onConfirm();
                  cancelFunc();
                },
                child: Text(
                  "确定",
                  style: TextStyle(color: Colors.blue),
                ),
              )
            ],
          ),
        ));
  });
}

void showToast(String msg){
  BotToast.showText(text:msg);
}