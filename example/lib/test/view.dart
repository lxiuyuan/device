import 'package:drive/drive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'controller.dart';
import 'fragment1.dart';
import 'fragment2.dart';
import 'fragment3.dart';

class Test1Page extends BasePage<Test1Controller> {
  @override
  Widget build(BuildContext context) {
    print("allBuild");
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: FragmentWidget(
                  controller: c.fragmentController,
                  children: <BaseController>[
                    Fragment1Controller(),
                    Fragment2Controller(),
                    Fragment3Controller(),
                  ],
                ),
              ),
              FlatButton(onPressed: c.onClick, child: Text("切换"))
            ],
          ),
        ),
      ),
    );
  }
}
