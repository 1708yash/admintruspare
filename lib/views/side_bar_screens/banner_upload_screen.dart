import 'package:flutter/material.dart';

class BannerScreen extends StatelessWidget {
  static const String routeName ='\BannerUploadScreen';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: const Text(
            'Upload Banners',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
          ),
        ),
          Divider(
            color: Colors.orange,
          ),
          Row(
            children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                height: 140,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  border: Border.all(color: Colors.orange.shade400),
                  borderRadius: BorderRadius.circular(8)
                ),

                child: Center(
                  child: Text('Click Here to Upload'),
                ),
              ),
            ),
              ElevatedButton(onPressed: (){}, child: Text('Save Banner')),
            ],
          ),
        ]
      ),
    );
  }
}
