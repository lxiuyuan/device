import 'package:drive/drive.dart';
import 'package:flutter/material.dart';
class Fragment1 extends BasePage{
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("fragment1"),);
  }
}

class Fragment1Controller extends BaseController{
  Fragment1Controller() : super(Fragment1());


}