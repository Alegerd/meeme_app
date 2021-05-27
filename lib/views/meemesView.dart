import 'package:flutter/material.dart';
import 'package:meeme_app/model/user.dart';
import 'package:meeme_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:meeme_app/model/meemeImage.dart';
import 'package:meeme_app/model/meeme.dart';
import 'package:meeme_app/views/meemeView.dart';

class MeemesView extends StatefulWidget {
  MeemesView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MeemesViewState();
}

class MeemesViewState extends State<MeemesView>
    with AutomaticKeepAliveClientMixin<MeemesView> {
  AppUser user;
  List<Meeme> meemes;
  List<MeemeView> feedData;

  buildFeed() {
    if (feedData != null) {
      return ListView(
        children: feedData.reversed.toList(),
      );
    } else {
      return Container(
          alignment: FractionalOffset.center,
          child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    _refresh();
    user = Provider.of<AppUser>(context);
    _getFeed();
    super.build(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: buildFeed(),
      ),
    );
  }

  Future<Null> _refresh() async {
    await _getFeed();
    setState(() {});
    return;
  }

  _getFeed() async {
    List<MeemeView> listOfPosts;
    meemes = await DatabaseService().getMeemes();
    AppUser userFromDb = await DatabaseService().getUser(user.id);
    listOfPosts = _generateFeed(meemes, userFromDb);
    setState(() {
      feedData = listOfPosts;
    });
  }

  List<MeemeView> _generateFeed(List<Meeme> posts, userFromDb) {
    List<MeemeView> listOfPosts = [];

    for (var post in posts) {
      listOfPosts.add(MeemeView.fromPost(post, userFromDb));
    }

    return listOfPosts;
  }

  @override
  bool get wantKeepAlive => true;
}

// ignore: must_be_immutable
class ActivityFeedItem extends StatelessWidget {
  final String username;
  final String
      userId; // types include liked photo, follow user, comment on photo
  final String mediaUrl;
  final String mediaId;

  ActivityFeedItem({this.username, this.userId, this.mediaUrl, this.mediaId});

  factory ActivityFeedItem.fromPost(MeemeImage post, AppUser user) {
    return ActivityFeedItem(
      username: user.firstName,
      userId: user.id,
      mediaUrl: post.imageUrl,
      mediaId: post.id,
    );
  }

  Widget mediaPreview = Container();
  String actionText = "actionText";

  void configureItem(BuildContext context) {
    mediaPreview = GestureDetector(
      child: Container(
        height: 45.0,
        width: 45.0,
        child: AspectRatio(
          aspectRatio: 487 / 451,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.fill,
              alignment: FractionalOffset.topCenter,
              image: NetworkImage(mediaUrl),
            )),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    configureItem(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('MeemeApp',
            style: const TextStyle(
                fontFamily: "Billabong", color: Colors.black, fontSize: 35.0)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Image.network(mediaUrl),
    );
  }
}
