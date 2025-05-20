import 'package:flutter/material.dart';

OverlayEntry createStatusOverlayEntry(
  BuildContext context,
  LayerLink layerLink,
  Function(String) onStatusSelected,
) {
  const double overlayWidth = 120;
  return OverlayEntry(
    builder: (context) => Positioned(
      width: overlayWidth,
      child: CompositedTransformFollower(
        link: layerLink,
        showWhenUnlinked: false,
        offset: const Offset(-overlayWidth + 40, 24),
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(4.0),
          child: Column(
            children: [
              buildStatusOption(context, 'ToDo', onStatusSelected),
              buildStatusOption(context, 'InProgress', onStatusSelected),
              buildStatusOption(context, 'Done', onStatusSelected),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget buildStatusOption(
  BuildContext context,
  String status,
  Function(String) onStatusSelected,
) {
  return ListTile(
    title: Text(
      status,
      style: const TextStyle(fontSize: 14),
    ),
    onTap: () {
      onStatusSelected(status);
    },
  );
}





Widget buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 14),
              ),
              if (label == 'Priority' || label == 'End Time')
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(
                    Icons.arrow_drop_down,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}


Widget buildPriorityOption(
  BuildContext context,
  String priority,
  Function(String) onPrioritySelected,
) {
  return ListTile(
    title: Text(
      priority,
      style: const TextStyle(fontSize: 14),
    ),
    onTap: () {
      onPrioritySelected(priority);
    },
  );
}

Widget buildCalendar(BuildContext context, DateTime selectedDate,
    Function(DateTime) onDateSelected) {
  final DateTime now = DateTime.now();
  DateTime firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
  int daysInMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
  int firstWeekday = firstDayOfMonth.weekday % 7; // Adjust for Sunday start

  return Container(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_left, size: 20),
              onPressed: () {
                final newDate = DateTime(selectedDate.year, selectedDate.month - 1, 1);
                onDateSelected(newDate);
              },
            ),
            Text(
              "${getMonthName(selectedDate.month)} ${selectedDate.year}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_right, size: 20),
              onPressed: () {
                final newDate = DateTime(selectedDate.year, selectedDate.month + 1, 1);
                onDateSelected(newDate);
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text('Sun', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Text('Mon', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Text('Tue', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Text('Wed', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Text('Thu', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Text('Fri', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Text('Sat', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 7,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          children: List.generate(firstWeekday + daysInMonth, (index) {
            if (index < firstWeekday) {
              return const SizedBox.shrink();
            }
            final day = index - firstWeekday + 1;
            final date = DateTime(selectedDate.year, selectedDate.month, day);
            final isSelected = date.day == selectedDate.day &&
                date.month == selectedDate.month &&
                date.year == selectedDate.year;
            final isToday = date.day == now.day &&
                date.month == now.month &&
                date.year == now.year;

            return GestureDetector(
              onTap: () => onDateSelected(date),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.blue
                      : (isToday ? Colors.blue.withOpacity(0.2) : null),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    ),
  );
}



String getMonthName(int month) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  return months[month - 1];
}

String normalizeStatus(String status) {
  switch (status.toLowerCase()) {
    case 'to do':
    case 'todo':
      return 'To Do';
    case 'in progress':
    case 'inprogress':
      return 'In Progress';
    case 'done':
      return 'Done';
    default:
      return 'To Do';
  }
}

String formatDisplayDate(String isoDate) {
  if (isoDate.isEmpty) return 'Select Date';
  try {
    final date = DateTime.parse(isoDate);
    return '${date.day}/${date.month}/${date.year}';
  } catch (e) {
    return isoDate;
  }
}