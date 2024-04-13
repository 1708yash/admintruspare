import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardScreen extends StatelessWidget {
  static const String routeName = '/dashboard_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Users',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 20),
              _buildBuyerList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBuyerList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('buyers').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final List<DocumentSnapshot> buyers = snapshot.data!.docs;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buyers.map((buyer) {
            final String buyerId = buyer['buyerId'] ?? '';
            final String fullName = buyer['fullName'] ?? '';
            final String phoneNumber = buyer['phoneNumber'] ?? '';
            final String profileImage = buyer['profileImage'] ?? '';

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              child: ListTile(
                leading: profileImage.isNotEmpty
                    ? CircleAvatar(
                  backgroundImage: NetworkImage(profileImage),
                )
                    : Icon(Icons.account_circle),
                title: Text(fullName),
                subtitle: Text(phoneNumber),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(onPressed: () {
                      _deleteAccount(context, buyerId);
                    },
                        child: Text("Delete user Account")),
                   SizedBox(width: 10,),
                    Text('ID: $buyerId'),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Future<void> _deleteAccount(BuildContext context, String buyerId) async {
    try {
      // Delete user document from Firestore collection 'buyers'
      await FirebaseFirestore.instance.collection('buyers').doc(buyerId).delete();

      // Get user reference from Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;

      // Check if the user is authenticated
      if (user != null) {
        // Delete user from Firebase Authentication
        await user.delete();
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account for buyer ID $buyerId has been deleted.'),
        ),
      );
    } catch (e) {
      // Show error message if deletion fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete account. Error: $e'),
        ),
      );
    }
  }
}
