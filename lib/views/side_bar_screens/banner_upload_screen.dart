import 'package:admintruspare/views/side_bar_screens/widgets/banner_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class BannerScreen extends StatefulWidget {
  static const String routeName = '\BannerUploadScreen';

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? fileName;

  dynamic _image;

  // image picker function for the banner image upload
  pickImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);
    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    }
  }

// firebase upload and save image function

  _uploadBannersToStorage(dynamic image) async {
    Reference ref = _storage.ref().child('banners').child(fileName!);
    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadToFirebaseStore() async {
    EasyLoading.show();
    if (_image != null) {
      String imageUrl = await _uploadBannersToStorage(_image);
      await _firestore.collection('banners').doc(fileName).set({
        'image': imageUrl,
      }).whenComplete(() {
        EasyLoading.dismiss();
        setState(() {
          _image = null;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Upload Banners',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
            ),
          ),
          Divider(
            color: Colors.orange,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Container(
                      height: 140,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          border: Border.all(color: Colors.orange.shade400),
                          borderRadius: BorderRadius.circular(8)),
                      child: _image != null
                          ? Image.memory(
                        _image,
                        fit: BoxFit.cover,
                      )
                          : Center(
                        child: Icon(
                          Icons.upload_file_sharp,
                          size: 36,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                        onPressed: () {
                          pickImage();
                        },
                        child: Text('Upload Banner'))
                  ],
                ),
              ),
              SizedBox(
                width: 30,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      textStyle: TextStyle(color: Colors.white)),
                  onPressed: () {
                    uploadToFirebaseStore();
                  },
                  child: Text('Save Banner')),
            ],
          ),
          Divider(
            color: Colors.orange,
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Banners Running',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          BannerWidget(context: context),
        ],
      ),
    );
  }
}
