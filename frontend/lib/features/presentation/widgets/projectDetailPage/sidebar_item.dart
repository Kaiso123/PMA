import 'package:flutter/material.dart';

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback? onTap; 

  const SidebarItem({
    Key? key,
    required this.icon,
    required this.title,
    this.isSelected = false,
    this.onTap, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: onTap, 
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue[50] : Colors.transparent,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Row(
            children: [
              Icon(icon,
                  color: isSelected ? Colors.blue : Colors.black54, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.blue : Colors.black87,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
