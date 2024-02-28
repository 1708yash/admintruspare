import 'package:flutter/material.dart';

class VendorsScreen extends StatelessWidget {
  static const String routeName ='\VendorsScreen';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(10),
        child: const Text(
          'Vendors and associates',
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
