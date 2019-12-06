import 'package:flutter/material.dart';

class KeyboardSpaceController{

  AnimationController animationController;
  Duration duration;

  void registerAnimationController(AnimationController animationController){
    this.animationController=animationController;
    _initListener();
  }

  void _initListener(){
    animationController.addListener((){
      transformY=transYTween.lerp(animationController.value);
      setState();
    });
  }

  Tween transYTween;

  State _state;

  var transformY=0.0;

  void registerState(State state){
    this._state=state;
  }

  var height=0;
  ///待哦state
  void setState() {
    try {
      if (_state?.mounted) {
        _state?.setState(() {});
      }
    } catch (e) {
      print(e);
      Future.delayed(Duration(milliseconds: 50), () {
        setState();
      });
    }
  }

  BuildContext get context=>_state?.context;
  void didChangeMetrics() async {
    await Future.delayed(Duration(milliseconds: 50));
    try {
      var m = MediaQuery.of(context);
      //获取键盘高度
      var keyHeight = m.viewInsets.bottom;
      if (keyHeight < 30) {
        if (transformY != 0.0) {
          animToTransY(0);
        }
        return;
      }
      var screenBottom = m.size.height - keyHeight;
      var focusScope = FocusScope.of(context);
      if (focusScope == null) {
        return;
      }
      var focus = focusScope.focusedChild;

      ///获取控件的底部位置
      var focusBottom = focus.offset.dy + focus.size.height;
      //计算移动的距离
      var cut = screenBottom - focusBottom - 15;
      //判断键盘遮挡输入框
      if (cut < 0 && transformY != cut) {
//      transformY=transformY+cut;
        animToTransY(transformY + cut);
      }
    }catch(e){
      print(e);
    }

  }



  void animToTransY(double y){
    transYTween=Tween(begin: transformY,end: y);
    animationController.stop(canceled: true);
    animationController.reset();
    animationController.animateTo(1.0,duration: duration,curve: Curves.fastOutSlowIn);
  }


}