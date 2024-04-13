import 'package:admintruspare/views/side_bar_screens/widgets/category_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CategoriesScreen extends StatefulWidget {
  static const String routeName = '\CategoryScreen';

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? fileName;

  dynamic _image;
  String? categoryName;
  String? subCategoryName;
  String? SmallSubCategoryName;
  _uploadCategoryBannerToStore(dynamic image) async {
    Reference ref = _storage.ref().child('categoryImages').child(fileName!);
    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadCategory() async {
    EasyLoading.show();
    if (_formKey.currentState!.validate()) {
      String imageUrl = await _uploadCategoryBannerToStore(_image);
      await _firestore.collection('categories').doc(fileName).set({
        'image': imageUrl,
        'categoryName': categoryName,
        'subCategoryName':subCategoryName,
        'smallSubCategory':SmallSubCategoryName,
      }).whenComplete(() {
        EasyLoading.dismiss();
        setState(() {
          _image = null;
          _formKey.currentState!.reset();
        });
      });
    } else {
      print("Not working");
    }
  }

  // image picker function for the banner image upload
  _pickImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);
    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Upload New Category',
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
                          _pickImage();
                        },
                        child: Text('Upload'))
                  ],
                ),
              ),
              Flexible(
                child: SizedBox(
                  width: 240,
                  child: TextFormField(
                    onChanged: (value) {
                      categoryName = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This field can not remain blank';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter Category Name',
                      hintText: 'Mechanical',
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              // subcategory input field
              Flexible(child: SizedBox(
                width: 240,
                child: TextFormField(
                  onChanged: (value) {
                    subCategoryName = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field can not remain blank';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter Sub-category Name',
                    hintText: 'Brake ',
                  ),
                ),
              )
              ),
              SizedBox(
                width: 30,
              ),
              //small sub category
              Flexible(child: SizedBox(
                width: 240,
                child: TextFormField(
                  onChanged: (value) {
                    SmallSubCategoryName = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field can not remain blank';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter Small Sub Category',
                    hintText: 'Brake Shoe',
                  ),
                ),
              )
              ),
              SizedBox(
                width: 30,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      textStyle: TextStyle(color: Colors.white)),
                  onPressed: () {
                    uploadCategory();
                  },
                  child: Text('Save In Category List')),
            ],
          ),

          Divider(
            color: Colors.orange,
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Category List Online',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
            ),
          ),

        CategoryWidget(),
        ]),
      ),
    );
  }
}
