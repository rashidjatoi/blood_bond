import '/common/widgets/shimmer_effect/shimmer.dart';
import '/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ECategoryShimmer extends StatelessWidget {
  const ECategoryShimmer({this.itemCount = 6, super.key});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, __) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Image
              EShimmerEffect(width: 55, height: 55, radius: 55),
              SizedBox(height: ESizes.spaceBtwItems / 2),

              /// Text
              EShimmerEffect(width: 55, height: 8),
            ],
          );
        },
        separatorBuilder: (_, __) =>
            const SizedBox(width: ESizes.spaceBtwItems),
        itemCount: itemCount,
      ),
    );
  }
}
