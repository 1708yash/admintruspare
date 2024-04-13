import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admintruspare/views/side_bar_screens/widgets/vendor_details_page.dart';

class VendorsScreen extends StatelessWidget {
  static const String routeName = '/vendors_screen';

  Widget _rowHeader(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          color: Colors.cyan,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendors and Associates'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  _rowHeader('LOGO', 2),
                  _rowHeader('Vendor Shop Name', 3),
                  _rowHeader('City', 2),
                  _rowHeader('State', 2),
                  _rowHeader('Action', 1),
                  _rowHeader('View More', 1),
                ],
              ),
            ),
            _buildVendorList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('vendors').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final List<DocumentSnapshot> vendors = snapshot.data!.docs;
        return Column(
          children: vendors.map((vendor) {
            final String businessName = vendor['businessName'] ?? '';
            final String cityValue = vendor['cityValue'] ?? '';
            final String stateValue = vendor['stateValue'] ?? '';
            final String profileImage = vendor['profileImage'] ?? '';

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: profileImage.isNotEmpty
                        ? Image.network(profileImage)
                        : Text('No Image'),
                  ),
                  Expanded(flex: 3, child: Text(businessName)),
                  Expanded(flex: 2, child: Text(cityValue)),
                  Expanded(flex: 2, child: Text(stateValue)),
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteVendor(context, vendor.id); // Use vendor.id
                      },
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        // Navigate to vendor details page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VendorDetailsPage(vendor: vendor),
                          ),
                        );
                      },
                      child: Text('View More'),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Future<void> _deleteVendor(BuildContext context, String vendorId) async {
    try {
      await FirebaseFirestore.instance.collection('vendors').doc(vendorId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vendor ID $vendorId deleted successfully.'),
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete vendor. Error: $e'),
        ),
      );
    }
  }
}
