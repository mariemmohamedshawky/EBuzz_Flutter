import 'package:ebuzz/components/warning_popup.dart';
import 'package:ebuzz/models/post_model.dart';
import 'package:ebuzz/providers/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewsScreen extends StatefulWidget {
  static const String routeName = 'news-screen';
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
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
          await Provider.of<Post>(context, listen: false).viewPosts(index);
      moreData = Provider.of<Post>(context, listen: false).items;
      usersPosts.addAll(moreData);
    } catch (error) {
      print(error);
      WarningPopup.showWarningDialog(
          context, false, 'SomeThing Went Wrong..', () {});
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

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        controller: _scrollController,
        itemCount: usersPosts.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == usersPosts.length) {
            return _buildProgressIndicator();
          } else {
            return Wrap(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 2),
                  child: Center(
                    child: Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                            child: Row(
                              children: [
                                Container(
                                  width: 80.0,
                                  height: 50.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            usersPosts[index].userPhoto ?? '')),
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 8, 4),
                                        child: Text(
                                          usersPosts[index].userName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                      ),
                                      Text(
                                        usersPosts[index].date,
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Wrap(
                                children: [
                                  Center(
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(25, 10, 25, 3),
                                      child: (Text(
                                        usersPosts[index].description ?? '',
                                        style: TextStyle(fontSize: 14),
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(25, 10, 25, 8),
                                height: 160.0,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                      BorderRadiusDirectional.circular(16.0),
                                  image: new DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          usersPosts[index].postPhoto ?? "")),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(40, 0, 40, 8),
                                child: Container(
                                  child: (Row(
                                    children: [
                                      Icon(
                                        Icons.place,
                                        color: Color(0xFF8C0202),
                                        size: 24,
                                      ),
                                      Text(
                                        usersPosts[index].city,
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  )),
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
