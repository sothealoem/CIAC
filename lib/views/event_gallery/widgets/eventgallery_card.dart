import 'package:flutter/material.dart';
import 'package:schoolapp/core/core.dart';

class ActivityCardWidget extends StatelessWidget {
  const ActivityCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 5.padAll,
      margin: 5.padAll,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.0,
        ),
        itemBuilder: (context, index) {
          return YourGridItemWidget(index: index);
        },
        itemCount: 10,
      ),
    );
  }
}

class YourGridItemWidget extends StatelessWidget {
  final int index;

  const YourGridItemWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          'Item $index',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
