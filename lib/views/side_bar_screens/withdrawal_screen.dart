import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WithdrawalScreen extends StatelessWidget {
  static const String routeName = '/WithdrawalScreen';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('returns').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final List<DocumentSnapshot> returns = snapshot.data!.docs;
        if (returns.isEmpty) {
          return Center(child: Text('No returns found'));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Return Requests',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: returns.length + 1, // Add 1 for labels row
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // Labels row
                      return Row(
                        children: [
                          Expanded(child: Text('Order ID', textAlign: TextAlign.center)),
                          Expanded(child: Text('Timestamp', textAlign: TextAlign.center)),
                          Expanded(child: Text('Total Amount', textAlign: TextAlign.center)),
                          Expanded(child: Text('Product', textAlign: TextAlign.center)),
                          Expanded(child: Text('Address', textAlign: TextAlign.center)),
                          Expanded(child: Text('Actions', textAlign: TextAlign.center)),
                        ],
                      );
                    }

                    // Data rows
                    final returnData = returns[index - 1];
                    final orderID = returnData['orderID'];
                    final timestamp = returnData['timestamp'].toDate();
                    final totalAmount = returnData['totalAmount'];
                    final List<dynamic> products = returnData['products'];
                    final List<dynamic> addressIDs = returnData['addressIDs'];

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order ID: $orderID',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Timestamp: $timestamp',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Total Amount: ₹$totalAmount',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(products.length, (index) {
                                final productData = products[index];
                                final productTitle = productData['productTitle'];
                                final quantity = productData['quantity'];
                                final addressID = addressIDs[index];

                                // Fetch address from addressID
                                return FutureBuilder<DocumentSnapshot>(
                                  future: FirebaseFirestore.instance.collection('addresses').doc(addressID).get(),
                                  builder: (context, addressSnapshot) {
                                    if (addressSnapshot.connectionState == ConnectionState.waiting) {
                                      return SizedBox();
                                    }
                                    if (addressSnapshot.hasError) {
                                      return Text('Error: ${addressSnapshot.error}');
                                    }
                                    final addressData = addressSnapshot.data!;
                                    final address = addressData['street'];
                                    final city = addressData['city'];
                                    final state = addressData['state'];

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Product: $productTitle',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Quantity: $quantity',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          'Address: $address, $city, $state',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    );
                                  },
                                );
                              }),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _sendToVendor(context, returnData);
                                  },
                                  child: Text('Send to Vendor'),
                                ),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Reason',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _sendToVendor(BuildContext context, DocumentSnapshot returnData) async {
    // Fetch productID from returnData
    final List<dynamic> products = returnData['products'];
    final String productID = products.isNotEmpty ? products[0]['productID'] : '';

    // Fetch vendorID from products collection
    final productSnapshot = await FirebaseFirestore.instance.collection('products').doc(productID).get();
    final String vendorID = productSnapshot['vendorID'];


    // Push the complete details of the return to a sub-collection named "returns" within the vendor's document
    final Map<String, dynamic> returnDetails = {
      'orderID': returnData['orderID'],
      'timestamp': returnData['timestamp'],
      'totalAmount': returnData['totalAmount'],
      'products': returnData['products'],
      'addressIDs': returnData['addressIDs'],
      'reason': 'Reason text', // You can replace this with the actual reason from the text field
    };

    await FirebaseFirestore.instance.collection('vendors').doc(vendorID).collection('returns').add(returnDetails);

    // Show alert based on success or failure
    final snackBar = SnackBar(
      content: Text('Details sent to vendor successfully'),
      duration: Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
