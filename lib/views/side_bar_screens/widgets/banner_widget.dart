import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  final Stream<QuerySnapshot> _bannerStream = FirebaseFirestore.instance
      .collection('banners')
      .snapshots();

  final BuildContext context;

  BannerWidget({required this.context});

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
            child: CircularProgressIndicator(
              color: Colors.cyan,
            ),
          );
        }

        return GridView.builder(
          itemCount: snapshot.data!.size,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final bannerData = snapshot.data!.docs[index];
            return Stack(
              children: [
                SizedBox(
                  height: 100,
                  width: 250,
                  child: Image.network(bannerData['image']),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteBanner(context, bannerData.id);
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> deleteBanner(BuildContext context, String bannerId) async {
    try {
      await FirebaseFirestore.instance
          .collection('banners')
          .doc(bannerId)
          .delete();
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error Deleting Banner'),
            content: Text('An error occurred while deleting the banner: $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
