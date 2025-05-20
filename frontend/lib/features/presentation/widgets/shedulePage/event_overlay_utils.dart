import 'package:flutter/material.dart';

Widget buildDetailRow(String label, String value, {Color? color}) {
  return Row(
    children: [
      Text(
        '$label:',
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      const SizedBox(width: 8),
      if (color != null)
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      if (color != null) const SizedBox(width: 8),
      Expanded(
        child: Text(
          value,
          style: const TextStyle(fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      const Icon(Icons.arrow_drop_down, size: 20, color: Colors.grey),
    ],
  );
}

Widget buildColorOption(
  BuildContext context,
  String colorHex,
  String colorName,
  Function(String) onSelect,
) {
  return InkWell(
    onTap: () => onSelect(colorHex),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: Color(int.parse('FF${colorHex.replaceFirst("#", "")}', radix: 16)),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(colorName, style: const TextStyle(fontSize: 14)),
        ],
      ),
    ),
  );
}