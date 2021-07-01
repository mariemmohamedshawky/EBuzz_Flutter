import 'dart:io';

import 'package:ebuzz/components/drower.dart';
import 'package:ebuzz/components/warning_popup.dart';
import 'package:ebuzz/constants/constant.dart';
import 'package:ebuzz/models/city_model.dart';
import 'package:ebuzz/providers/city.dart';
import 'package:ebuzz/providers/post.dart';
import 'package:ebuzz/screens/myposts_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class UpdatepostScreen extends StatefulWidget {
  static const String routeName = 'updatepost-screen';
  String postImage;
  String description;
  int postId;
  int cityId;
  CityModel selectedCity;
  @override
  _UpdatepostScreenState createState() => _UpdatepostScreenState();
}

class _UpdatepostScreenState extends State<UpdatepostScreen> {
  final _descriptionController = TextEditingController();
  File _image;
  final picker = ImagePicker();
  List<CityModel> cities = [];
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      getCities();

      final args =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      setState(() {
        widget.postImage = args['image'];
        widget.cityId = args['city_id'];
        widget.postId = args['id'];
        widget.selectedCity =
            CityModel(id: args['city_id'], name: args['city']);
        widget.description = args['description'];
        _descriptionController..text = args['description'];
      });
    }
    setState(() {
      _isInit = false;
    });
    super.didChangeDependencies();
  }

  void getCities() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<City>(context, listen: false).viewCities();
      setState(() {
        cities = Provider.of<City>(context, listen: false).items;
      });
    } catch (error) {
      print(error);
      WarningPopup.showWarningDialog(
          context,
          false,
          translator.translate(
            'wrong-message',
          ),
          () {});
      return;
    }

    setState(() {
      _isLoading = false;
    });
  }

  void getImages(BuildContext context, ImageSource source) async {
    final pickedFile = await picker.getImage(source: source, imageQuality: 50);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    Navigator.of(context).pop();
  }

  void _submitForm() async {
    if (_descriptionController.text.isEmpty) {
      WarningPopup.showWarningDialog(
          context,
          false,
          translator.translate(
            'post-description-message',
          ),
          () {});
      return;
    } else if (widget.selectedCity == null) {
      WarningPopup.showWarningDialog(
          context,
          false,
          translator.translate(
            'post-city-message',
          ),
          () {});
      return;
    } else {
      setState(() {
        _isLoading = true;
      });
      try {
        var success = await Provider.of<Post>(context, listen: false)
            .updatePost(_image, _descriptionController.text,
                widget.selectedCity.id, widget.postId);
        if (success) {
          WarningPopup.showWarningDialog(
              context,
              true,
              translator.translate(
                'update-post-success',
              ),
              () {});
          Navigator.of(context).pushNamedAndRemoveUntil(
              MypostsScreen.routeName, (Route<dynamic> route) => false);
        } else {
          WarningPopup.showWarningDialog(context, false,
              Provider.of<Post>(context, listen: false).errorMessage, () {});
        }
      } catch (error) {
        WarningPopup.showWarningDialog(
            context,
            false,
            translator.translate(
              'wrong-message',
            ),
            () {});
        return;
      }

      setState(() {
        _isLoading = false;
      });
    }
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
                    translator.translate(
                      'post-image',
                    ),
                    // style: theme.textTheme.headline5,
                    style: TextStyle(
                        fontSize: 18,
                        color: primary,
                        fontWeight: FontWeight.bold),
                  ),
                ]),
                // SizedBox(
                //   height: mediaQuery.size.height * 0.05,
                // ),
                Divider(
                  color: grey,
                  height: 20,
                  thickness: 2,
                  indent: 1,
                  endIndent: 1,
                ),
                TextButton(
                  style: TextButton.styleFrom(primary: theme.primaryColor),
                  child: Text(
                    translator.translate(
                      'image-camera',
                    ),
                    //style: theme.textTheme.bodyText1,
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
                    translator.translate(
                      'image-gallery',
                    ),
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
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: grey),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      drawer: Container(
        width: 250,
        child: Drawer(
          child: Container(child: MyDrawer()),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.fromLTRB(6, 20, 6, 10),
                      height: 30,
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                              text: translator.translate(
                                'post-message-black-1',
                              ),
                              style: TextStyle(color: Colors.grey),
                              children: [
                                TextSpan(
                                  text: translator.translate(
                                    'post-message-red-1',
                                  ),
                                  style: TextStyle(
                                      color: Color(0xFF8C0202),
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                    text: translator.translate(
                                      'post-message-black-2',
                                    ),
                                    style: TextStyle(color: Colors.grey)),
                                TextSpan(
                                  text: translator.translate(
                                    'post-message-red-2',
                                  ),
                                  style: TextStyle(
                                      color: Color(0xFF8C0202),
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: '.')
                              ]),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 10, 5, 15),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        height: 370,
                        color: secondary,
                        child: Column(
                          children: [
                            Wrap(children: [
                              Container(
                                padding: EdgeInsets.all(4),
                                margin: EdgeInsets.all(8),
                                height: 30,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.place_outlined,
                                      color: Color(0xFF8C0202),
                                      size: 22,
                                    ),
                                    Text(
                                      widget.selectedCity != null
                                          ? widget.selectedCity.name
                                          : translator.translate(
                                              'post-location',
                                            ),
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 270,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8, 16, 16, 8),
                                      child: Container(
                                        height: 55,
                                        child: Form(
                                          child: TextField(
                                            decoration:
                                                InputDecoration.collapsed(
                                              hintText: translator.translate(
                                                'post-hint',
                                              ),
                                              hintStyle: TextStyle(
                                                color: grey,
                                                fontSize: 14,
                                              ),
                                            ),
                                            keyboardType:
                                                TextInputType.multiline,
                                            controller: _descriptionController,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      height: 180,
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                                16.0),
                                        image: new DecorationImage(
                                            fit: BoxFit.cover,
                                            image: _image != null
                                                ? FileImage(_image)
                                                : NetworkImage(widget
                                                        .postImage ??
                                                    "https://cdn.questionpro.com/userimages/site_media/no-image.png")),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ]),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: FloatingActionButton.extended(
                                    backgroundColor: secondary,
                                    elevation: 0,
                                    onPressed: () {
                                      _openImagePicker(
                                          context,
                                          Theme.of(context),
                                          MediaQuery.of(context));
                                    },
                                    icon: Icon(
                                      Icons.add_photo_alternate_outlined,
                                      color: Color(0xFF8C0202),
                                    ),
                                    label: Text(
                                      translator.translate(
                                        'post-photo',
                                      ),
                                      style: TextStyle(
                                        color: Color(0xFF8C0202),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 13),
                                    height: mediaQuery.size.height * 0.03,
                                    child: DropdownButtonFormField<CityModel>(
                                      menuMaxHeight: 150,
                                      decoration: InputDecoration.collapsed(
                                          hintText: ''),
                                      hint: Text(
                                        translator.translate(
                                          'post-city-hint',
                                        ),
                                      ),
                                      value: widget.selectedCity != null
                                          ? cities.firstWhere((c) =>
                                              c.id == widget.selectedCity.id)
                                          : widget.selectedCity,
                                      items: cities.map(
                                        (value) {
                                          return DropdownMenuItem<CityModel>(
                                            value: value,
                                            child: Text(value.name),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          widget.selectedCity = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          _submitForm();
                        },
                        backgroundColor: Color(0xFF8C0202),
                        icon: Icon(Icons.file_upload_outlined),
                        label: Text(
                          translator.translate(
                            'update-post-button',
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
