import 'package:drive/drive.dart';
import 'package:flutter/cupertino.dart';
import 'view.dart';
class TestController extends BaseController{
  String textKey="text";
  int text=0;
  TestController(BuildContext context) : super(TestPage());

  void initState() {
  }

  void resume() {
  }

  void pause() {
  }

  void dispose() {
  }

  void onLoadingClick() async {
    text++;
    setState(k:textKey);
    return;
    showLoading();
    await Future.delayed(Duration(milliseconds: 3000));
    dismissLoading();

  }

}