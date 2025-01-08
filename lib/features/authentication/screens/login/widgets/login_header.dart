import 'package:flutter/material.dart';

import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class ELoginHeader extends StatelessWidget {
  const ELoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image(
            image: AssetImage(
              dark ? EImages.appLogo : EImages.appLogo,
            ),
            height: 150,
          ),
        ),
        Text(ETexts.loginTitle,
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: ESizes.sm),
        Text(ETexts.loginSubTitle,
            style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
