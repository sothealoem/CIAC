import 'package:flutter/material.dart';

class CustomTopTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onChanged;

  const CustomTopTabBar({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      {"icon": Icons.menu, "title": "ទាំងអស់"},
      {"icon": Icons.access_time, "title": "កំពុងធ្វើ"},
      {"icon": Icons.check, "title": "បានអនុម័ត"},
      {"icon": Icons.close, "title": "បដិសេធ"},
    ];

    return Container(
      color: Colors.white,
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        tabs[index]["icon"] as IconData,
                        size: 15,
                        color: isSelected ? Colors.black : Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        tabs[index]["title"] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected ? Colors.black : Colors.grey,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 80),
                    height: 3,
                    width: double.infinity,
                    color:
                        isSelected
                            ? Colors.green
                            : const Color.fromARGB(92, 200, 217, 226),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
