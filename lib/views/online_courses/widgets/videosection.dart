import 'package:flutter/material.dart';

class VideoSectionWidget extends StatelessWidget {
  List videoList = [
    'Introduction of Flutter',
    'Installing Flutter On Windows',
    'Setup Emulator on Windows',
    'Creating Our First App',
    'Creating Our First App',
    'Creating Our First App',
    'Creating Our First App',
  ];

  VideoSectionWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: videoList.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Card(
          child: Container(
            margin: const EdgeInsets.only(top: 5.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              leading: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color:
                      index == 0
                          ? Colors.deepPurple
                          : Colors.deepPurple.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow_rounded,

                  color: Colors.white,
                  size: 30,
                ),
              ),
              title: Text(videoList[index]),
              subtitle: Text("20 min 50sec"),
            ),
          ),
        );
      },
    );
  }
}
