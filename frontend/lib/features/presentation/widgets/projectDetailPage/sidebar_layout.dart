import 'package:doan/features/domain/entities/project.dart';
import 'package:doan/features/presentation/pages/projectDetail/backlog_page.dart';
import 'package:doan/features/presentation/pages/projectDetail/calendar.dart';
import 'package:doan/features/presentation/pages/projectDetail/list_page.dart';
import 'package:doan/features/presentation/pages/projectDetail/schedule_page.dart';
import 'package:doan/features/presentation/pages/projectDetail/sumary_page.dart';
import 'package:doan/features/presentation/pages/projectDetail/timeline_page.dart';
import 'package:doan/features/presentation/widgets/projectDetailPage/sidebar_item.dart';
import 'package:flutter/material.dart';

class SidebarLayout extends StatefulWidget {
  final Project project;
  final bool isSidebarOpen;
  final VoidCallback onToggle;

  const SidebarLayout({
    Key? key,
    required this.project,
    required this.isSidebarOpen,
    required this.onToggle,
  }) : super(key: key);

  @override
  State<SidebarLayout> createState() => _SidebarLayoutState();
}

class _SidebarLayoutState extends State<SidebarLayout> {
  late PageController _pageController;
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 2);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    print('Tapped item: $index'); // Debug log
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
    print('Jumped to page: $index'); // Debug log
    widget.onToggle();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 62,
          bottom: 0,
          left: 0,
          right: 0,
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (index) {
              print('Page changed to: $index'); // Debug log
              setState(() {
                _selectedIndex = index;
              });
            },
            children: [
              SummaryPage(project: widget.project),
              TimelinePage(project: widget.project),
              BacklogPage(project: widget.project),
              CalendarPage(project: widget.project),
              ListPage(project: widget.project),
              SchedulePage(project: widget.project),
              const Center(child: Text("Add Views")),
            ],
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          top: 62,
          bottom: 0,
          left: widget.isSidebarOpen ? 0 : -210,
          width: 210,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                right: BorderSide(
                  color: Colors.blueGrey,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.build, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        widget.project.name ?? 'Unnamed Project',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'PLANNING',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SidebarItem(
                  icon: Icons.dashboard,
                  title: 'Summary',
                  isSelected: _selectedIndex == 0,
                  onTap: () => _onItemTapped(0),
                ),
                SidebarItem(
                  icon: Icons.timeline,
                  title: 'Timeline',
                  isSelected: _selectedIndex == 1,
                  onTap: () => _onItemTapped(1),
                ),
                SidebarItem(
                  icon: Icons.backpack,
                  title: 'Backlog',
                  isSelected: _selectedIndex == 2,
                  onTap: () => _onItemTapped(2),
                ),
                SidebarItem(
                  icon: Icons.calendar_today,
                  title: 'Calendar',
                  isSelected: _selectedIndex == 3,
                  onTap: () => _onItemTapped(3),
                ),
                SidebarItem(
                  icon: Icons.list,
                  title: 'List',
                  isSelected: _selectedIndex == 4,
                  onTap: () => _onItemTapped(4),
                ),
                SidebarItem(
                  icon: Icons.edit,
                  title: 'Schedule',
                  isSelected: _selectedIndex == 5,
                  onTap: () => _onItemTapped(5),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Divider(),
                ),
                SidebarItem(
                  icon: Icons.edit,
                  title: 'Add Views',
                  isSelected: _selectedIndex == 6,
                  onTap: () => _onItemTapped(6),
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'DEVELOPMENT',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    "You're in a team-managed project",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'LEARN MORE',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SidebarToggleButton extends StatelessWidget {
  final bool isSidebarOpen;
  final VoidCallback onToggle;

  const SidebarToggleButton({
    Key? key,
    required this.isSidebarOpen,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      bottom: 200,
      left: isSidebarOpen ? 200 : -5,
      child: GestureDetector(
        onTap: onToggle,
        child: Container(
          width: 20,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              isSidebarOpen ? Icons.arrow_left : Icons.arrow_right,
              color: Colors.black,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}