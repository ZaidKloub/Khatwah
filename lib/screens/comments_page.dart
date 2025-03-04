import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String postId = 'example_post_id';
    return MaterialApp(
      title: 'Khatwah Comments',
      home: CommentsPage(postId: postId),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Comment {
  final String userName;
  final String userImage;
  final String comment;
  final DateTime time;

  Comment({
    required this.userName,
    required this.userImage,
    required this.comment,
    required this.time,
  });
}

class CommentsPage extends StatefulWidget {
  final String postId;

  CommentsPage({required this.postId});

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  TextEditingController commentController = TextEditingController();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _userName;
  String? _profilePicturePath;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await _db.collection('Users').doc(user.uid).get();
      setState(() {
        _userName = userData['FullName'] ?? 'Anonymous';
        _profilePicturePath = userData['Profile Image'] ?? 'https://example.com/default_image.png';
      });
    }
  }

  Future<void> _addComment() async {
    if (commentController.text.isNotEmpty && _userName != null && _profilePicturePath != null) {
      await _db.collection('Comments').add({
        'userName': _userName!,
        'userImage': _profilePicturePath!,
        'text': commentController.text,
        'timestamp': Timestamp.now(),
        'postId': widget.postId,
      });
      commentController.clear();
    } else {
      print('User data is incomplete. Please log in again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _db.collection('Comments')
                  .where('postId', isEqualTo: widget.postId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading comments'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No comments yet'));
                }
                var comments = snapshot.data!.docs.map((doc) => Comment(
                  userName: doc['userName'],
                  userImage: doc['userImage'],
                  comment: doc['text'],
                  time: (doc['timestamp'] as Timestamp).toDate(),
                )).toList();
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(comments[index].userImage),
                      ),
                      title: Text(comments[index].userName),
                      subtitle: Text(comments[index].comment),
                      trailing: Text(comments[index].time.toString()),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      labelText: 'Write a comment...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


