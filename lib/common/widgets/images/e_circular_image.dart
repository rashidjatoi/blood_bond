import 'package:cached_network_image/cached_network_image.dart';
import '/common/widgets/shimmer_effect/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/sizes.dart';

class ECircularImage extends StatelessWidget {
  const ECircularImage({
    super.key,
    this.overlayColor,
    this.backgroundColor,
    this.width = 56,
    this.height = 56,
    this.padding = ESizes.sm,
    this.isNetworkImage = false,
    required this.image,
    this.fit = BoxFit.cover,
  });

  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;
  final bool isNetworkImage;
  final String image;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: backgroundColor,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Center(
          child: isNetworkImage
              ? CachedNetworkImage(
                  fit: fit,
                  color: overlayColor,
                  imageUrl: image,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      const EShimmerEffect(width: 55, height: 55),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
              : const CircleAvatar(
                  radius: 40,
                  child: Icon(
                    Iconsax.user,
                    size: 25,
                  ),
                ),
        ),
      ),
    );
  }
}
