import 'package:flutter/material.dart';

class TopBarItem extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final double iconSize;
  final Color iconColor;
  final bool isSelected;
  final VoidCallback? onTap;

  const TopBarItem({
    Key? key,
    this.title,
    this.icon,
    this.iconSize = 24.0,
    this.iconColor = Colors.black,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            if (icon != null)
              Icon(
                icon!,
                size: iconSize,
                color: isSelected ? Colors.blue : iconColor,
              )
            else if (title != null)
              Text(
                title!,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.blue : Colors.black,
                ),
              ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4.0),
                height: 2,
                width: 20,
                color: Colors.blue,
              ),
          ],
        ),
      ),
    );
  }
}