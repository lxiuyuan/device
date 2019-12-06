
import 'package:flutter/material.dart';

class TabWidgetController {


  State state;

  void registerState(State state) {
    this.state = state;
  }


  BuildContext get context => state?.context;

  void setState({State state}) {
    state=state??this.state;
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




  AnimationController _animationController;


  void registerAnimation(AnimationController animationController) {
    _animationController = animationController;
    _initAnimListener();
  }
  ///联合滚动
  void combinationWithPage(PageController pageController){
    pageController.addListener((){
      this.position=pageController.page;
    });
    this.addItemClickListener((index){

      pageController.animateToPage(index, duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
    });
  }

  void _initAnimListener() {
    _animationController.addListener(() {
      var val = _animationController.value;
      this._position = _tween.lerp(val);
      var index=0;
      ///计算index
      if(val>=0.5){
        index=_tween.end.toInt();
      }else{
        index=_tween.begin.toInt();
      }
      if(_index!=index){
        _changeChangeListener(index);
      }
      _index=index;
      _changeAnimListener();
      setState();
    });
  }

  Tween _tween;
  double _position = 0.0;
  double get position=>_position;
  set position(p){
    _position=p;
    ///计算position；
    var intPosition=position.toInt();
    var suffix=_position-intPosition;
    var index=intPosition;
    if(suffix>=0.5){
      index=intPosition+1;
    }
    //判断是否index有变化
    if(this._index!=index){
      this._index=index;
      _changeChangeListener(index);
    }

    setState();
  }

  int page=0;
  int _index=0;
  List<VoidCallback> _animListeners = [];
  List<IntListener> _changeListeners = [];
  List<IntListener> _changeItemClickListeners = [];

  void addChangeListener(IntListener listener){
    removeChangeListener(listener);
    _changeListeners.add(listener);
  }

  void removeChangeListener(IntListener listener){
    if(_changeListeners.contains(listener)){
      _changeListeners.remove(listener);
    }
  }
  void addItemClickListener(IntListener listener){
    removeItemClickListener(listener);
    _changeItemClickListeners.add(listener);
  }

  void removeItemClickListener(IntListener listener){
    if(_changeListeners.contains(listener)){
      _changeItemClickListeners.remove(listener);
    }
  }

  void addAnimListener(VoidCallback listener) {
    removeAnimListener(listener);
    _animListeners.add(listener);
  }

  void removeAnimListener(VoidCallback listener) {
    if (_animListeners.contains(listener)) {
      _animListeners.remove(listener);
    }
  }

  void _changeAnimListener() {
//    if(_animListeners.length==0){
//      return;
//    }
    for (var value in _animListeners) {
      value();
    }
  }
  void _changeItemClickListener(int index) {
    for (var value in _changeItemClickListeners) {
      value(index);
    }
  }
  void _changeChangeListener(int p) {
    this.page=p;
    setState();
    for (var value in _changeListeners) {
      value(p);
    }
  }

  void animToPosition(double position, {Duration duration, Curve curve}) {
    _tween = Tween(begin: this.position, end: position);
    _animationController.reset();
    _animationController.animateTo(1.0,
        duration: duration ?? Duration(milliseconds: 400),
        curve: curve ?? Curves.fastOutSlowIn);
  }

  void onItemClick(int i) {
    _changeItemClickListener(i);
    animToPosition(i.toDouble());
  }
}

typedef IntListener =Function(int);
