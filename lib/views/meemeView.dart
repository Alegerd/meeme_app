import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meeme_app/model/user.dart';
import 'package:provider/provider.dart';
import 'package:meeme_app/model/meeme.dart';
import 'package:meeme_app/services/database.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';

class MeemeView extends StatefulWidget {
  const MeemeView(
      {this.mediaUrl,
      this.meemeText,
      this.username,
      this.likes,
      this.postId,
      this.ownerId});

  factory MeemeView.fromDocument(DocumentSnapshot document) {
    return MeemeView(
      mediaUrl: document['imageUrl'],
      meemeText: document['text'],
      likes: document['likes'],
      postId: document.id,
      ownerId: document['userId'],
    );
  }

  factory MeemeView.fromPost(Meeme meeme, AppUser user) {
    return MeemeView(
      username: user == null ? "" : user.firstName,
      mediaUrl: meeme.imageUrl,
      meemeText: meeme.text,
      likes: meeme.likes,
      ownerId: meeme.userId,
      postId: meeme.id,
    );
  }

  int getLikeCount(var likes) {
    if (likes == null) {
      return 0;
    }
    var vals = likes.values;
    int count = 0;
    for (var val in vals) {
      if (val == true) {
        count = count + 1;
      }
    }

    return count;
  }

  final String mediaUrl;
  final String meemeText;
  final String username;
  final likes;
  final String postId;
  final String ownerId;

  _ImagePost createState() => _ImagePost(
        mediaUrl: this.mediaUrl,
        meemeText: this.meemeText,
        username: this.username,
        likes: this.likes,
        likeCount: getLikeCount(this.likes),
        ownerId: this.ownerId,
        postId: this.postId,
      );
}

class _ImagePost extends State<MeemeView> {
  final String mediaUrl;
  final String meemeText;
  final String username;
  Map likes;
  int likeCount;
  final String postId;
  bool liked;
  final String ownerId;

  bool showHeart = false;

  TextStyle boldStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  var reference = FirebaseFirestore.instance.collection('posts');
  AppUser user;

  _ImagePost(
      {this.mediaUrl,
      this.meemeText,
      this.username,
      this.likes,
      this.postId,
      this.likeCount,
      this.ownerId});

  GestureDetector buildLikeIcon() {
    Color color;
    IconData icon;

    if (liked) {
      color = Colors.pink;
      icon = FontAwesomeIcons.solidHeart;
    } else {
      icon = FontAwesomeIcons.heart;
    }
    icon = FontAwesomeIcons.heart;
    return GestureDetector(
        child: Icon(
          icon,
          size: 25.0,
          color: color,
        ),
        onTap: () {
          _likePost(postId);
        });
  }

  GestureDetector buildLikeableImage() {
    return GestureDetector(
      onDoubleTap: () => _likePost(postId),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CachedNetworkImage(
            width: MediaQuery.of(context).size.width / 2,
            imageUrl: mediaUrl,
            fit: BoxFit.fitWidth,
            placeholder: (context, url) => loadingPlaceHolder,
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          showHeart
              ? Positioned(
                  child: Container(
                    width: 100,
                    height: 100,
                    child: Opacity(
                        opacity: 0.85,
                        child: FlareActor(
                          "assets/flare/Like.flr",
                          animation: "Like",
                        )),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  buildPostHeader({String ownerId}) {
    if (ownerId == null) {
      return Text("owner error");
    }

    return FutureBuilder(
        future: DatabaseService().getUser(ownerId),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(snapshot.data.profileImageUrl),
                backgroundColor: Colors.grey,
              ),
              title: GestureDetector(
                child: Text(snapshot.data.firstName, style: boldStyle),
              ),
            );
          }
          return Container();
        });
  }

  Container loadingPlaceHolder = Container(
    height: 400.0,
    child: Center(child: CircularProgressIndicator()),
  );

  @override
  Widget build(BuildContext context) {
    user = Provider.of<AppUser>(context);
    liked = user == null ? false : (likes[user.id] == true);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildPostHeader(ownerId: ownerId),
        buildLikeableImage(),
        Container(
            margin: EdgeInsets.only(top: 15),
            child: Text(meemeText,
                style: boldStyle,
                textAlign: TextAlign.center,
                textScaleFactor: 2)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: const EdgeInsets.only(left: 20.0, top: 40.0)),
            Padding(padding: const EdgeInsets.only(left: 20.0, top: 40.0)),
            buildLikeIcon(),
            Padding(padding: const EdgeInsets.only(right: 5.0)),
            Container(
              margin: const EdgeInsets.only(left: 5.0),
              child: Text(
                "$likeCount likes",
                style: boldStyle,
              ),
            )
          ],
        ),
      ],
    );
  }

  void _likePost(String postId2) {
    if (user == null)
      return;

    var userId = user.id;
    bool _liked = likes[userId] == true;

    if (_liked) {
      print('removing like');
      reference.doc(postId).update({'likes.$userId': false});

      setState(() {
        likeCount = likeCount - 1;
        liked = false;
        likes[userId] = false;
      });
    }

    if (!_liked) {
      print('liking');
      setState(() {
        likeCount = likeCount + 1;
        liked = true;
        likes[userId] = true;
        showHeart = true;
      });
      Timer(const Duration(milliseconds: 2000), () {
        setState(() {
          showHeart = false;
        });
      });
      reference.doc(postId).update({'likes.$userId': true});
    }
  }

  void removeActivityFeedItem() {
    FirebaseFirestore.instance
        .collection("insta_a_feed")
        .doc(ownerId)
        .collection("items")
        .doc(postId)
        .delete();
  }
}
