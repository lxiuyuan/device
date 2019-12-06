import 'package:flutter/material.dart';
import 'controller.dart';

class KeyboardSpace extends StatefulWidget {
  final Widget child;
  final bool enable;
  final Duration duration;
  KeyboardSpace({@required this.child,this.enable=true,this.duration=const Duration(milliseconds: 300)});
  @override
  _KeyboardSpaceState createState() => _KeyboardSpaceState();
}

class _KeyboardSpaceState extends State<KeyboardSpace> with WidgetsBindingObserver,SingleTickerProviderStateMixin {

  KeyboardSpaceController c=new KeyboardSpaceController();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    c.registerState(this);
    c.duration=widget.duration;
    c.registerAnimationController(AnimationController(vsync: this));
    super.initState();
  }

  @override
  void didChangeMetrics() async {
    super.didChangeMetrics();
    if(widget.enable) {
      c.didChangeMetrics();
    }

  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    c.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(offset: Offset(0,c.transformY),child: Container(child: widget.child,));
  }
}
