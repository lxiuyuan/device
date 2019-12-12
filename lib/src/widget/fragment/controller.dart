import 'package:drive/drive.dart';
import 'package:flutter/material.dart';

class FragmentController {
  State state;
  int index=0;
  FragmentWidget get widget{
    if(state?.widget==null){
      return null;
    }
    return state.widget as FragmentWidget;
  }
  GlobalKey stackKey=GlobalKey();
  void registerState(State state){
    this.state=state;
  }
  BuildContext get context => state?.context;

  void setState() {
    try {
      if (state?.mounted) {
        state?.setState(() {});
      }
    } catch (e) {
      print(e);
      Future.delayed(Duration(milliseconds: 50), () {
        setState();
      });
    }
  }

  bool isFirst=true;
  void firstResume() async {
    if(!isFirst){
      return;
    }
    isFirst=false;
    await Future.delayed(Duration(milliseconds: 50));
    resume();
  }
  ///重新渲染回调，
  void resume(){
    if(widget==null){
      return;
    }
    var baseController=widget.children[this.index];
    baseController.resume();
    baseController.page?.onResume();
  }

  //暂停回掉
  void pause({int i}){
    if(widget==null){
      return;
    }
    var index=i??this.index;
    var baseController=widget.children[index];
    baseController.pause();
    baseController.page?.onPause();
  }

  void animToPage(int index){
    var oldIndex=this.index;
    this.index=index;
    setState();
    resume();
    pause(i:oldIndex);
  }

//遍历查询渲染界面方法
  void _visitorResumeElement(Element element,_VisitorElement visitor){
    int i=0;
    element?.visitChildren((e){
      if(e is StatefulElement){
        if(e.state is FragmentApplifeyListener) {
          if (i == this.index) {
            var f = e.state as FragmentApplifeyListener;
            f.onResume();
          }
          i++;
          visitor.isRun = false;
          return;
        }
      }
      _visitorResumeElement(e, visitor);
    });
  }

//  遍历查询暂停接口
  void _visitorPauseElement(Element element,_VisitorElement visitor, int index){
    int i=0;
    element?.visitChildren((e){
      if(e is StatefulElement){
        if(e.state is FragmentApplifeyListener) {
          if (i == index) {
            var f = e.state as FragmentApplifeyListener;
            f.onPause();
          }
          i++;
          visitor.isRun = false;
          return;
        }
      }
      _visitorPauseElement(e, visitor,index);
    });
  }





}

class _VisitorElement{
  bool isRun=true;
}

mixin FragmentApplifeyListener{
  void onPause(){}
  void onResume(){}
}