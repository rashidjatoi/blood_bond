import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class EProfileMenu extends StatelessWidget {
  const EProfileMenu({
    super.key,
    this.icon = Iconsax.arrow_right_34,
    required this.onPressed,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String title, value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      onTap: onPressed,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium!,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        value,
        style: Theme.of(context).textTheme.labelMedium,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Icon(icon, size: 18),
    );
  }
}
