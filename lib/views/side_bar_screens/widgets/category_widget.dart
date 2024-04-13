import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  final Stream<QuerySnapshot> _categoriesStream = FirebaseFirestore.instance
      .collection('categories').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _categoriesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: Colors.cyan,),
          );
        }

        return GridView.builder(itemCount: snapshot.data!.size,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6, mainAxisSpacing: 8, crossAxisSpacing: 8),
            itemBuilder: (context,index){
          final categoryData =snapshot.data!.docs[index];
            return Column(
              children: [
                SizedBox(
                  height: 60,
                  width: 60,
                  child: Image.network(categoryData['image']),
                ),
                Text(categoryData['categoryName'],style: TextStyle(fontSize: 14),),
                Text(categoryData['subCategoryName'],style: TextStyle(fontSize: 12)),
                Text(categoryData['smallSubCategory'],style: TextStyle(fontSize: 10)),
              ],
            );
            });
      },
    );
  }
}
