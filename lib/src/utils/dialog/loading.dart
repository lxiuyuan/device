import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dialog.dart';

class LoadingUtils {
  static bool isLoading=false;
  static void show({String text}) {
    print("isLoadingzzz");
    if(isLoading){
      print("isLoadingTur");
      return;
    }
    isLoading=true;
    DialogUtils.showCenterDialog(Loading(text: text), type: "loading",onDismissListener: (){
      isLoading=false;
    });
  }

  static void dismiss() {

    isLoading=false;
    DialogUtils.dismissCenterDialog(type: "loading");
  }
}

///视图
class Loading extends StatelessWidget {
  final String text;

  Loading({this.text});

  @override
  Widget build(BuildContext context) {
//    if(text==null){
    return GestureDetector(
        onTap: () {},
        child: Container(
            color: Color(0x01ffffff),
            child: Center(
              child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CupertinoActivityIndicator(
                    radius: 15,
                  )),
            )));
//    }

//    return Center(
//      child: Container(
//        constraints: BoxConstraints(minWidth: 120),
//        padding: EdgeInsets.only(left: 13,right: 13,top:13,bottom: 14),
//        decoration: BoxDecoration(
//            color: Color(0xcc000000), borderRadius: BorderRadius.circular(4)),
//
//        child: Column(
//          mainAxisSize: MainAxisSize.min,
//          children: <Widget>[
//            Padding(
//                padding: const EdgeInsets.only(bottom: 4),
//                child: SizedBox(width: 28,height: 28,child: CupertinoActivityIndicator())),
//
//            Text("${text}",style: TextStyle(inherit: false,fontSize: 14,color: Colors.white,),),
//          ],
//        ),
//      ),
//    );
  }
}
