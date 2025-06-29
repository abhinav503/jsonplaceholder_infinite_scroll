import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jsonplaceholder_infinite_scroll/core/ui/atoms/custom_icon_widget.dart';

class CustomNetworkImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double height;
  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.width = 30.0,
    this.height = 30.0,
  });

  @override
  State<CustomNetworkImage> createState() => _CustomNetworkImageState();
}

class _CustomNetworkImageState extends State<CustomNetworkImage> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      width: widget.width,
      height: widget.height,
      fit: BoxFit.cover,
      errorWidget: (context, error, stackTrace) {
        return CustomIconWidget(
          icon: Icons.photo,
          color: Colors.grey,
          size: widget.height,
        );
      },
      placeholder: (context, url) {
        return CustomIconWidget(
          icon: Icons.photo,
          color: Colors.grey,
          size: widget.height,
        );
      },
    );
  }
}
