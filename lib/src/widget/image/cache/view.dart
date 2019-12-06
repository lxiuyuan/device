
import 'package:flutter/material.dart';
import 'widget.dart';

///图片缓存
class CachedImage extends StatefulWidget {
  CachedImage(this.url,
      {this.header,
      this.scale = 1.0,
      this.width,
      this.height,
      this.loadingImage="images/pic_placeholder_list.png",
      this.isMember = true,
      this.fit});

  final String url;
  final bool isMember;
  final Map<String, String> header;
  final double scale;
  final double width;
  final double height;
  final String loadingImage;
  final BoxFit fit;

  @override
  _CachedImageState createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {


  @override
  void didUpdateWidget(CachedImage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

//  CachedNetworkImage(widget.url,headers:widget.header,scale:widget.scale)

//  CachedNetworkImage(widget.url,
//  header: widget.header,
//  scale: widget.scale,
//  isMemboy: widget.isMember),

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      placeholder: AssetImage("${widget.loadingImage}"),
      repeat: ImageRepeat.noRepeat,
      image:CachedNetworkImage(widget.url,
          header: widget.header,
          scale: widget.scale,
          isMemboy: widget.isMember),
      fadeInDuration: Duration(milliseconds: 100),
      fadeOutDuration: Duration(milliseconds:150),
      fadeOutCurve: Curves.ease,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
    );
  }
}
