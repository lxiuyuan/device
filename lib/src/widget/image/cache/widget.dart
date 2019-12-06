import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:convert' as convert;
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:drive/src/utils/http.dart';

///
/// 图片缓存到本地的
///
///

Map<String, Uint8List> _images = {};
List<String> _names = [];
int _maxMember = 1024 * 1024 * 100; //1MB

void addPic(String name, Uint8List pic) {
  if (getPicsSize() > _maxMember) {
    removeFirstPic();
  }

  if (_images.containsKey(name)) {
    _images[name] = pic;
  } else {
    _images.putIfAbsent(name, () => pic);
  }
  _names.add(name);
}

Uint8List getPic(String name) {
  if (_images.containsKey(name)) {
    return _images[name];
  }
  return null;
}

void removePic(String name) {
  if (_images.containsKey(name)) {
    _images.remove(name);
  }
  _names.remove(name);
}

void removeFirstPic() {
  var name = _names[0];
  removePic(name);
}

int getPicsSize() {
  var l = 0;
  for (var value in _images.values) {
    l + value.length;
  }
  return l;
}

//内存管理

class CachedNetworkImage extends ImageProvider<CachedNetworkImage> {
  const CachedNetworkImage(this.url,
      {this.isCached = true, this.header, this.isMemboy = true, this.scale})
      : assert(url != null),
        assert(scale != null);

  final String url;

  //是否是保存到内存卡
  final bool isCached;
  final bool isMemboy;
  final double scale;
  final Map<String, String> header;

  @override
  Future<CachedNetworkImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<CachedNetworkImage>(this);
  }
  operator==(dynamic other){
    if (other.runtimeType != runtimeType) return false;
    final CachedNetworkImage typedOther = other;

    return url == typedOther.url && scale == typedOther.scale;
  }


  @override
  ImageStreamCompleter load(CachedNetworkImage key) {
    return MultiFrameImageStreamCompleter(

      codec: _loadAsync(key),
      scale: key.scale,
      informationCollector:() sync* {
        yield ErrorDescription('Path:error');
      },
    );
  }

  //进行下载加载
  Future<Codec> _loadAsync(CachedNetworkImage key) async {
    Uint8List bytes = null;
    var name = md5.convert(convert.utf8.encode(key.url)).toString();
    if(isMemboy){
      bytes=getPic(name);
    }
    //判断是否加载sd卡
    if (isCached&&bytes!=null) {
      bytes = await _getFromImage(name);
      if(isMemboy){
        addPic(name, bytes);
      }
    }

    if (bytes != null &&
        bytes?.lengthInBytes != null &&
        bytes.lengthInBytes != 0) {
      return await PaintingBinding.instance.instantiateImageCodec(bytes);
    }


    bytes=await HttpUtils.httpDownload(url);


    if(bytes==null){
      return null;
    }
    if(isMemboy && bytes.lengthInBytes != 0){
      addPic(name, bytes);
    }
    //缓存到本地
    if (isCached && bytes.lengthInBytes != 0) {
      _saveToImage(bytes, name);
    }
    if (bytes.lengthInBytes == 0)
      throw Exception('MyNetworkImage is an empty file: ${key.url}');
    return await PaintingBinding.instance.instantiateImageCodec(bytes);
  }



  @override
  int get hashCode => hashValues(url, scale);

  @override
  String toString() {
    return '$runtimeType("$url", scale: $scale)';
    ;
  }

  ///保存图片
  void _saveToImage(Uint8List bytes, String name) async {
    Directory dir = await getTemporaryDirectory();
    String path = dir.path + "/image/" + name;
    var file = File(path);
    bool exist = await file.exists();
    if (!exist) {
      var parentExists = await file.parent.exists();
      if (!parentExists) {
        await file.parent.create();
      }
      file = await file.create();
      file.writeAsBytesSync(bytes);
    }
  }

  //获取图片
  Future<Uint8List> _getFromImage(String name) async {
    Directory dir = await getTemporaryDirectory();
    String path = dir.path + "/image/" + name;
    var file = File(path);
    bool exist = await file.exists();

    if (exist) {
      final Uint8List bytes = await file.readAsBytes();
      return bytes;
    }

    return null;
  }
}
