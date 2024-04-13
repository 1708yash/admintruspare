import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VendorDetailsPage extends StatefulWidget {
  final DocumentSnapshot vendor;

  const VendorDetailsPage({required this.vendor});

  @override
  _VendorDetailsPageState createState() => _VendorDetailsPageState();
}

class _VendorDetailsPageState extends State<VendorDetailsPage> {
  late bool _isVerified;

  @override
  void initState() {
    super.initState();
    _isVerified = widget.vendor['verified'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendor Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteVendor(context, widget.vendor.id);
            },
          ),
          IconButton(
            icon: Icon(Icons.verified),
            color: _isVerified ? Colors.green : null,
            onPressed: () {
              _toggleVerification(widget.vendor.id);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    widget.vendor['businessName'] ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(widget.vendor.id),
                ),
                Divider(),
                _buildDetailTile('Street Address', widget.vendor['streetAddress'] ?? ''),
                _buildDetailTile('Pin Code', widget.vendor['pinCode'] ?? ''),
                _buildDetailTile('City', widget.vendor['cityValue'] ?? ''),
                _buildDetailTile('State', widget.vendor['stateValue'] ?? ''),
                _buildDetailTile('Country', widget.vendor['countryValue'] ?? ''),
                _buildImageTile('Profile Image', widget.vendor['profileImage'] ?? ''),
                _buildImageTile('Verification Document', widget.vendor['verificationDoc'] ?? ''),
                _buildDetailTile('Phone Number', widget.vendor['phoneNumber'] ?? ''),
                _buildDetailTile('Email', widget.vendor['email'] ?? ''),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTile(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  Widget _buildImageTile(String title, String imageUrl) {
    return ListTile(
      title: Text(title),
      subtitle: Image.network(imageUrl),
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

  Future<void> _toggleVerification(String vendorId) async {
    try {
      final bool newVerificationStatus = !_isVerified;
      await FirebaseFirestore.instance.collection('vendors').doc(vendorId).update({
        'verified': newVerificationStatus,
      });
      setState(() {
        _isVerified = newVerificationStatus;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vendor ID $vendorId has been ${_isVerified ? 'verified' : 'unverified'}.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to toggle verification. Error: $e'),
        ),
      );
    }
  }
}
