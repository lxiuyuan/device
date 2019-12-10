# drive_example

Demonstrates how to use the drive plugin.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

##code

    Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              Stateful(bind: ()=>[controller.text],builder:(context){
                print("textKey");
                return Text("${controller.text}");
              },),
              Stateful(bind: ()=>[controller.text1],builder:(context){
                print("textKey1");
                return Text("${controller.text1}");
              },),
          FlatButton(onPressed: controller.onClick, child: Text("click")),
            ],
          ),
        ),
      ),
    );
