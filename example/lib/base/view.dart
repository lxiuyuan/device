import 'package:drive/drive.dart';
import 'package:drive_example/base/controller.dart';
import 'package:flutter/material.dart';

class TestPage extends BasePage<TestController>  {
  @override
  void initState() {
    super.initState();
  }

  FragmentController fragmentController=new FragmentController();


  @override
  Widget build(BuildContext context) {
    print("allContext");
    return Scaffold(
      appBar: AppBar(
        title: Text("BasePage"),
      ),
      body: Container(
        child: Column(
          children: [
            FlatButton(onPressed: controller.onLoadingClick, child: Text("loading")),
            Stateful(k:controller.textKey,builder:(c)=> Text("${controller.text}s"),),
          ],
        ),
      ),
    );
  }
}
