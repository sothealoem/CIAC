import 'package:flutter/material.dart';
import 'package:ciac_school/core/core.dart';

class EventGalleryCardWidget extends StatelessWidget {
  const EventGalleryCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 5.padAll,
      margin: 5.padAll,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
          crossAxisSpacing: 10, // Spacing between columns
          mainAxisSpacing: 10, // Spacing between rows
          childAspectRatio: 1.0, // Ratio of width to height for grid cells
        ),
        itemBuilder: (context, index) {
          return YourGridItemWidget(
            index: index,
          ); // Replace with your grid item widget
        },
        itemCount: 10, // Replace with the actual number of items in your grid
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
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
