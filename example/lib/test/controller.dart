import 'package:drive/drive.dart';
import 'package:flutter/material.dart';
import 'view.dart';
class Test1Controller extends BaseController{
  final String textKey="text";
  Test1Controller() : super(Test1Page());
  FragmentController fragmentController=new FragmentController();
  int text=0;
  int text1=0;


  @override
  void initState() {
    super.initState();
  }

  void onClick(){
    text++;
    text1=text%3;
    fragmentController.animToPage(text1);
//    setState();

  }


}