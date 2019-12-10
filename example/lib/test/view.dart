import 'package:drive/drive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'controller.dart';

class Test1Page extends BasePage<Test1Controller> {

  @override
  Widget build(BuildContext context) {
    print("allBuild");
    return Scaffold(
      appBar: AppBar(
        title: Text("testPage"),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              Stateful(
                  bind:()=> [controller.text],
                builder: (context) {
                  print("textBuild");
                  return Text("${controller.text}");
                }
              ),

              Stateful(
                  bind:()=> [controller.text1],
                builder: (context) {
                  print("textBuild1");
                  return Text("${controller.text1}");
                }
              ),
          FlatButton(onPressed: controller.onClick, child: Text("click")),
            ],
          ),
        ),
      ),
    );
  }
}
