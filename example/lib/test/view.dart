import 'package:drive/drive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'controller.dart';

class Test1Page extends BasePage<Test1Controller> {

  @override
  Widget build(BuildContext context) {
    print("allBuild");
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              Stateful(bind: ()=>[controller.text],builder:(context){
                print("textKey");
                return Text("${controller.text}");
              },),
              Stateful(bind: ()=>[controller.text1],builder:(context){
                print("textKey1");
                return Text("${controller.text1}");
              },),
          FlatButton(onPressed: controller.onClick, child: Text("click")),
            ],
          ),
        ),
      ),
    );
  }
}
