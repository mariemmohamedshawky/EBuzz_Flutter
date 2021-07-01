import 'package:ebuzz/components/drower.dart';
import 'package:ebuzz/constants/constant.dart';
import 'package:ebuzz/screens/updatepost_screen.dart';
import 'package:flutter/material.dart';
import 'package:ebuzz/components/warning_popup.dart';
import 'package:ebuzz/models/post_model.dart';
import 'package:ebuzz/providers/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class MypostsScreen extends StatefulWidget {
  static const String routeName = 'myposts-screen';

  @override
  _MypostsScreenState createState() => _MypostsScreenState();
}

class _MypostsScreenState extends State<MypostsScreen> {
  var _isLoading = false;
  var _isInit = true;
  var _loadMore = true;
  int totalPages;
  List<PostModel> usersPosts = [];
  List<PostModel> moreData = [];
  static int page = 1;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_loadMore) {
          getPosts(page);
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      getPosts(1);
    }
    setState(() {
      _isInit = false;
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> getPosts(int index) async {
    setState(() {
      _isLoading = true;
    });

    try {
      totalPages =
          await Provider.of<Post>(context, listen: false).viewMyPosts(index);
      moreData = Provider.of<Post>(context, listen: false).myPosts;
      usersPosts.addAll(moreData);
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
      if (page == totalPages) {
        print('end of lazy loading');
        _loadMore = false;
      } else {
        page++;
      }
    });
  }

  Future<void> _deletePost(int id) async {
    if (id == null) {
      WarningPopup.showWarningDialog(
          context,
          false,
          translator.translate(
            'mypost-post-id',
          ),
          () {});
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      var success =
          await Provider.of<Post>(context, listen: false).deletePost(id);
      if (!success) {
        WarningPopup.showWarningDialog(context, false,
            Provider.of<Post>(context, listen: false).errorMessage, () {});
      }

      Navigator.of(context).pushNamedAndRemoveUntil(
          MypostsScreen.routeName, (Route<dynamic> route) => false);
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
      WarningPopup.showWarningDialog(
          context,
          false,
          translator.translate(
            'wrong-message',
          ),
          () {});
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: grey),
        title: Text(
          translator.translate(
            'mypost-tittle',
          ),
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
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
          : ListView.builder(
              controller: _scrollController,
              itemCount: usersPosts.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == usersPosts.length) {
                  return _buildProgressIndicator();
                } else {
                  return Wrap(
                    children: [
                      Container(
                        child: Center(
                          child: Card(
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              25, 10, 25, 3),
                                          child: (Text(
                                            usersPosts[index].description ?? '',
                                            style: TextStyle(fontSize: 12),
                                          )),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(25, 10, 25, 8),
                                      height: 160.0,
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                                16.0),
                                        image: new DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                usersPosts[index].postPhoto ??
                                                    "")),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(30, 0, 32, 8),
                                      child: Container(
                                        child: (Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            TextButton.icon(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.place,
                                                color: Color(0xFF8C0202),
                                                size: 22,
                                              ),
                                              label: Text(
                                                usersPosts[index].city,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                TextButton.icon(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            UpdatepostScreen
                                                                .routeName,
                                                            arguments: {
                                                          'id':
                                                              usersPosts[index]
                                                                  .id,
                                                          'image':
                                                              usersPosts[index]
                                                                  .postPhoto,
                                                          'description':
                                                              usersPosts[index]
                                                                  .description,
                                                          'city_id':
                                                              usersPosts[index]
                                                                  .cityId,
                                                          'city':
                                                              usersPosts[index]
                                                                  .city,
                                                        });
                                                  },
                                                  icon: Icon(
                                                    Icons.edit,
                                                    color: primary,
                                                    size: 22,
                                                  ),
                                                  label: Text(
                                                    translator.translate(
                                                      'mypost-edit-label',
                                                    ),
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ),
                                                TextButton.icon(
                                                  onPressed: () async {
                                                    _deletePost(
                                                        usersPosts[index].id);
                                                  },
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Color(0xFF8C0202),
                                                    size: 22,
                                                  ),
                                                  label: Text(
                                                    translator.translate(
                                                      'mypost-delete-label',
                                                    ),
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        )),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${usersPosts[index].date}    (${usersPosts[index].status})',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 10),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: _isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
}
