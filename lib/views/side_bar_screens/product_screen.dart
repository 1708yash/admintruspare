import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductScreen extends StatelessWidget {
  static const String routeName = '/product_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products On Store'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTableHeaderRow(),
            SizedBox(height: 10),
            Expanded(
              child: _buildProductList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeaderRow() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
      ),
      child: Row(
        children: [
          _buildHeaderCell('Image', flex: 2),
          _buildHeaderCell('Name', flex: 3),
          _buildHeaderCell('Price of One Item', flex: 2),
          _buildHeaderCell('Minimum Quantity', flex: 2),
          _buildHeaderCell('Approve', flex: 1),
          _buildHeaderCell('Delete', flex: 1),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final List<DocumentSnapshot> products = snapshot.data!.docs;
        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return _buildProductItem(products[index]);
          },
        );
      },
    );
  }

  Widget _buildProductItem(DocumentSnapshot product) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: SizedBox(
          width: 80,
          height: 80,
          child: Image.network(
            product['imageURL'] ?? '',
            fit: BoxFit.cover,
          ),
        ),
        title: Text(product['productTitle'] ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: ${product['priceOfOneItem'] ?? ''}'),
            Text('Quantity: ${product['minimumQuantity'] ?? ''}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.check_circle, color: Colors.green),
              onPressed: () {
                product.reference.update({'approved': true});
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                product.reference.delete();
              },
            ),
          ],
        ),
      ),
    );
  }
}
