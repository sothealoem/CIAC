import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:swis_school/core/core.dart';

enum SingingCharacter2 { lafayette, jefferson, las }

class ScheduleCardWidget extends StatelessWidget {
  const ScheduleCardWidget({super.key});

  Widget _buildInfoRow(
    String label,
    String value,
    String label1,
    String value1,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("$label:", style: AppTextStyle.normalGreyRegular),
          const SizedBox(width: 8.0),
          Flexible(child: Text(value, style: const TextStyle(fontSize: 16.0))),
          Text("$label1:", style: AppTextStyle.normalGreyRegular),
          const SizedBox(width: 8.0),
          Flexible(child: Text(value1, style: const TextStyle(fontSize: 16.0))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 5.padAll,
      margin: 5.padAll,
      child: Card(
        child: Container(
          // Adjust the height as needed
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              // Card(
              //   child: Image.asset('assets/images/schedule.png'),
              // ),]
              SizedBox(
                width: 300,
                height: 200,
                child: PhotoView(
                  imageProvider: AssetImage('assets/images/schedule.png'),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 0.3,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 10),
                    child: Text(
                      "សម្រាប់ព័ត៌មានបន្ថែម៖",
                      style: AppTextStyle.smallPrimaryBold,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 10),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.phone, size: 14),
                        SizedBox(width: 8.0),
                        Text(
                          "078 358 272 / 096 250 1328",
                          style: AppTextStyle.smallGreyRegular,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 10),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.email, size: 14),
                        SizedBox(width: 8.0),
                        Text(
                          "info@softcreative.biz៖",
                          style: AppTextStyle.smallGreyRegular,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 10),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.web_asset, size: 14),
                        SizedBox(width: 8.0),
                        Text(
                          "www.softcreative.biz៖",
                          style: AppTextStyle.smallGreyRegular,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle button press
                        print('Button pressed');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppColor.primaryBtn, // Text color
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ), // Button padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            8,
                          ), // Button border radius
                        ),
                      ),
                      child: Text(
                        'For More Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              10.height,
            ],
          ),
        ),
      ),
    );
  }
}
