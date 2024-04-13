import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContactUScreen extends StatefulWidget {
  static const String routeName = '/ContactUsScreen';

  @override
  State<ContactUScreen> createState() => _ContactUScreenState();
}

class _ContactUScreenState extends State<ContactUScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Contact Us Messages',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('contactUs').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages available.'));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    var timestamp = (doc['timestamp'] as Timestamp).toDate();
                    var formattedTimestamp = DateFormat.yMMMMd().add_jm().format(timestamp);
                    var userId = doc['userId'];
                    var mobileNumber = doc['mobileNumber'];
                    var description = doc['description'];

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Timestamp: $formattedTimestamp'),
                            Text('User ID: $userId'),
                            Text('Mobile Number: $mobileNumber'),
                            Text('Description: $description'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
