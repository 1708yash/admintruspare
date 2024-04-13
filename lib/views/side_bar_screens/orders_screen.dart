import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = '/orders_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Upcoming Orders'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 20),
            _buildOrderList(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('orders').orderBy('timestamp', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final List<DocumentSnapshot> orders = snapshot.data!.docs;
        if (orders.isEmpty) {
          return Center(child: Text('No orders found'));
        }

        Map<String, List<DocumentSnapshot>> groupedOrders = {};

        // Group orders by order ID
        orders.forEach((order) {
          String orderID = order.id;
          groupedOrders.putIfAbsent(orderID, () => []);
          groupedOrders[orderID]!.add(order);
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: groupedOrders.entries.map((entry) {
            String orderID = entry.key;
            List<DocumentSnapshot> ordersWithSameID = entry.value;

            // Calculate total amount for orders with the same ID
            double totalAmount = ordersWithSameID.fold(0, (sum, order) {
              return sum + (order['totalAmount'] ?? 0);
            });

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
                      'Total Amount: ₹$totalAmount',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: ordersWithSameID.map((order) {
                        final List<dynamic>? products = order['products'];
                        final List<dynamic>? quantities = order['orderQuantities'];

                        if (products == null || quantities == null) {
                          return SizedBox(); // Skip rendering if essential data is missing
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: products.map((product) {
                            int index = products.indexOf(product);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Product: ${product}',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Quantity: ${quantities[index]}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 20),
                              ],
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
