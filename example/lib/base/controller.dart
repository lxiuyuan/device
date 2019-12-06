import 'package:drive/drive.dart';
import 'package:flutter/cupertino.dart';
import 'view.dart';
class TestController extends BaseController{
  String textKey="text";
  int text=0;
  TestController(BuildContext context) : super(TestPage());

  @override
  void initState() {
    super.initState();

  }

  @override
  void onResume() {
    super.onResume();
  }

  @override
  void onPause() {
    super.onPause();
  }

  @override
  void dispose() {
    super.dispose();
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