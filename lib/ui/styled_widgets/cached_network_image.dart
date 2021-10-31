import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StyledCachedNetworkImage extends StatelessWidget {
  const StyledCachedNetworkImage(
      {required this.url, required this.height, this.width});

  final url;
  final height;
  final width;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      height: height,
      width: width,
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
        ),
      ),
      placeholder: (context, url) =>
          Container(child: Center(child: new CupertinoActivityIndicator())),
      errorWidget: (context, url, error) {
        return Image(
          image: AssetImage("assets/image-not-found.svg"),
          fit: BoxFit.cover,
        );
      },
    );
  }
}

class StyledCachedNetworkImage2 extends StatelessWidget {
  const StyledCachedNetworkImage2({
    required this.url,
  });

  final url;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
        ),
      ),
      placeholder: (context, url) =>
          Container(child: Center(child: new CupertinoActivityIndicator())),
      errorWidget: (context, url, error) {
        return Image(
          image: AssetImage("assets/image-not-found.svg"),
          fit: BoxFit.cover,
        );
      },
    );
  }
}
