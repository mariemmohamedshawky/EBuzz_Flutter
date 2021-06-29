import 'package:ebuzz/constants/constant.dart';
import 'package:ebuzz/providers/user.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;

  ProfileImagePicker(this.imagePickFn);
  @override
  _ProfileImagePickerState createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  File _image;
  final picker = ImagePicker();

  void getImages(BuildContext context, ImageSource source) async {
    final pickedFile = await picker.getImage(source: source, imageQuality: 50);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        widget.imagePickFn(_image);
      } else {
        print('No image selected.');
      }
    });
    Navigator.of(context).pop();
  }

  void _openImagePicker(BuildContext context, theme, mediaQuery) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: mediaQuery.size.height * 0.28,
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: mediaQuery.size.height * 0.01,
                ),
                Row(children: <Widget>[
                  Text(
                    'pick image',
                    style: TextStyle(
                        fontSize: 18,
                        color: primary,
                        fontWeight: FontWeight.bold),
                  ),
                ]),
                TextButton(
                  style: TextButton.styleFrom(primary: theme.primaryColor),
                  child: Text(
                    'use Camera',
                    // style: theme.textTheme.bodyText1,
                    style: TextStyle(
                        fontSize: 14,
                        color: primary,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => getImages(context, ImageSource.camera),
                ),
                TextButton(
                  style: TextButton.styleFrom(primary: theme.primaryColor),
                  child: Text(
                    "use Gallary",
                    // style: theme.textTheme.bodyText1,
                    style: TextStyle(
                        fontSize: 14,
                        color: primary,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => getImages(context, ImageSource.gallery),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _image != null
              ? FileImage(_image)
              : NetworkImage(user.userData.photo),
        ),
        TextButton.icon(
          icon: Icon(Icons.image),
          label: Text('Add Image'),
          style: TextButton.styleFrom(primary: primary),
          onPressed: () {
            _openImagePicker(
                context, Theme.of(context), MediaQuery.of(context));
          },
        ),
      ],
    );
  }
}
