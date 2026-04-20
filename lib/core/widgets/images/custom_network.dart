import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swis_school/core/constants/asset_path.dart';
import 'package:swis_school/main.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width ?? Get.width,
      height: height ?? Get.height,
      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: const Duration(milliseconds: 200),
      fit: BoxFit.cover,
      errorWidget: (_, error, test) {
        customPrint('Failed to load network image $imageUrl');
        return _defaultImage();
      },
      placeholder: (_, _) {
        return _defaultImage();
      },
    );
  }

  Widget _defaultImage() {
    return Image.asset(
      AssetPath.placeholder.path,
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }
}
