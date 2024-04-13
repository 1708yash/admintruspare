import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {

  final Stream<QuerySnapshot> _bannerStream = FirebaseFirestore.instance
      .collection('banners').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _bannerStream,
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
              final bannerData =snapshot.data!.docs[index];
              return Column(
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: Image.network(bannerData['image']),
                  ),

                ],
              );
            });
      },
    );
  }
}
