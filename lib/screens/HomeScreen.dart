import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../modles/firestore_service.dart';
import '../widgets/carousel_slider.dart';
import 'Chat_Details.dart';
import 'DrawerScreen.dart'; // Ensure this class is defined or imported
import 'comments_page.dart'; // Ensure this class is defined or imported

class FeedData {
  final String userName;
  final String feedTime;
  final String feedText;
  final String feedUrl;
  final String? profilePictureUrl;
  final String? imageUrl;
  final File? postImage;
  final String userId;
  int likeCount;
  int commentCount;
  List<String> messages;
  bool isLiked;
  bool isSaved;
  Set<String> savedByUsers;
  Set<String> likedByUsers;
  final String postId;

  FeedData({
    required this.userName,
    required this.feedTime,
    required this.feedText,
    required this.feedUrl,
    this.profilePictureUrl,
    this.imageUrl,
    this.postImage,
    this.savedByUsers = const {},
    this.likedByUsers = const {},
    required this.likeCount,
    required this.commentCount,
    this.messages = const [],
    this.isLiked = false,
    this.isSaved = false,
    required this.postId,
    required  this.userId,
  });
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double xOffset = 0;
  double yOffset = 0;
  bool isDrawerOpen = false;
  String searchQuery = '';
  File? _image;
  String _userName = 'Default User';
  String _profilePicturePath = '';

  TextEditingController commentController = TextEditingController();
  TextEditingController feedTextController = TextEditingController();
  TextEditingController feedUrlController = TextEditingController();

  List<FeedData> feedData = [];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();
        setState(() {
          _userName = userData['FullName'] ?? _userName;
          _profilePicturePath =
              userData['Profile Image'] ?? _profilePicturePath;
        });
      } catch (e) {
        print('Error loading user data: $e');
      }
    }
  }

  Future<String> uploadImageToStorage(File image) async {
    try {
      String filePath =
          'posts/${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
      TaskSnapshot uploadTask =
      await FirebaseStorage.instance.ref(filePath).putFile(image);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  void addNewPost(String feedText, String feedUrl, File? image) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DateTime timestamp = DateTime.now();
      String? imageUrl;
      if (image != null) {
        imageUrl = await uploadImageToStorage(image);
      }

      DocumentReference postRef =
      FirebaseFirestore.instance.collection('Post').doc();
      String postId = postRef.id;

      FeedData newPost = FeedData(
        userName: _userName,
        feedTime: DateFormat('hh:mm a').format(timestamp),
        feedText: feedText,
        feedUrl: feedUrl,
        postImage: image,
        imageUrl: imageUrl,
        likeCount: 0,
        commentCount: 0,
        profilePictureUrl: _profilePicturePath,
        isLiked: false,
        isSaved: false,
        postId: postId,
        userId: user.uid ,
      );

      setState(() {
        feedData.add(newPost);
      });

      await postRef.set({
        'userID': user.uid,
        'text': feedText,
        'locationURL': feedUrl,
        'profilePictureUrl': _profilePicturePath,
        'timestamp': timestamp,
        'imageUrl': imageUrl,
        'likes': 0,
        'likedByUsers': [],
        'postId': postId,
      });

      Navigator.pop(context);
      feedTextController.clear();
      feedUrlController.clear();
      _image = null;
    } else {
      print("User not logged in");
    }
  }

  void _handleLike(
      FeedData feed, Function(bool, int, Set<String>) onLikeUpdated) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User not logged in.");
      return;
    }

    print("Handling like for user: ${user.uid} on post: ${feed.postId}");

    final DocumentReference postRef =
    FirebaseFirestore.instance.collection('Post').doc(feed.postId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(postRef);
      if (!snapshot.exists) {
        throw Exception("Post does not exist!");
      }

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      int currentLikes = data['likes'] as int;
      Set<String> likedByUsers =
      Set<String>.from(data['likedByUsers'] as List<dynamic>);

      print("Current likes: $currentLikes, Liked by users: $likedByUsers");

      if (likedByUsers.contains(user.uid)) {
        likedByUsers.remove(user.uid);
        currentLikes--;
      } else {
        likedByUsers.add(user.uid);
        currentLikes++;
      }

      transaction.update(postRef, {
        'likes': currentLikes,
        'likedByUsers': likedByUsers.toList(),
      });

      return <dynamic>[likedByUsers, currentLikes];
    }).then((result) {
      Set<String> updatedLikedByUsers =
      Set<String>.from(result[0] as List<dynamic>);
      int updatedLikes = result[1] as int;
      onLikeUpdated(updatedLikedByUsers.contains(user.uid), updatedLikes,
          updatedLikedByUsers);
      print(
          "Like updated: $updatedLikes, Updated liked by users: $updatedLikedByUsers");
    }).catchError((error) {
      print("Failed to update likes: $error");
    });
  }
  Future<void> navigateToChat(String targetUserId, String userName, String profilePictureUrl) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print("No user logged in");
      return;
    }

    // Generate chat ID as before
    List<String> users = [currentUser.uid, targetUserId];
    users.sort();
    String chatId = users.join('_');

    // Check if chat document exists or create a new one
    final chatDocRef = FirebaseFirestore.instance.collection('chats').doc(chatId);
    final chatDocSnapshot = await chatDocRef.get();

    if (!chatDocSnapshot.exists) {
      await chatDocRef.set({
        'participants': [currentUser.uid, targetUserId],
        'created_at': DateTime.now(),
      });
    }

    // Navigate to the chat page with all required parameters
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailsScreen(
          myUserID: currentUser.uid,
          otherUserID: targetUserId,
          userName: userName,
          profilePictureUrl: profilePictureUrl,
        ),
      ),
    );
  }




  Widget makeInteractionButton({
    required IconData icon,
    required String text,
    required VoidCallback? onPressed,
    Color color = Colors.grey,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, color: color, size: 18),
            SizedBox(width: 5),
            Text(text, style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }

  Widget makeSingleFeed(FeedData feed, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: feed.profilePictureUrl != null &&
                    feed.profilePictureUrl!.isNotEmpty
                    ? (feed.profilePictureUrl!.startsWith('http')
                    ? NetworkImage(feed.profilePictureUrl!) // For URLs
                    : FileImage(File(
                    feed.profilePictureUrl!)) // For local files
                ) as ImageProvider
                    : AssetImage(
                    "assets/default_profile_pic.jpg"), // Default image
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feed.userName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      feed.feedTime,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            feed.feedText,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 12),
          if (feed.imageUrl != null) // Check if imageUrl is not null
            Image.network(feed.imageUrl!),
          InkWell(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Click here to help',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      makeInteractionButton(
                        icon: feed.isLiked ? Icons.thumb_down : Icons.thumb_up,
                        text: "Like (${feed.likeCount})",
                        onPressed: () {
                          _handleLike(feed, (bool isLiked, int likeCount,
                              Set<String> likedByUsers) {
                            setState(() {
                              feed.isLiked = isLiked;
                              feed.likeCount = likeCount;
                              feed.likedByUsers = likedByUsers;
                            });
                          });
                        },
                      ),
                      // Add some space between the button and the text
                    ],
                  ),
                  makeInteractionButton(
                    icon: Icons.chat,
                    text: "Comment (${feed.commentCount})",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommentsPage(
                              postId: feed
                                  .feedUrl), // Assuming feedUrl is the postId
                        ),
                      );
                    },
                  ),
                  makeInteractionButton(
                    icon: Icons.message,
                    text: "Message",
                    onPressed: () {
                      navigateToChat(
                          feed.userId,
                          feed.userName,
                          feed.profilePictureUrl ?? "default_profile_url_or_empty_string"
                      );
                    },
                  ),

                ],
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          DrawerScreen(), // Ensure this class is defined or imported
          SizedBox(
            height: double.infinity,
            child: AnimatedContainer(
              transform: Matrix4.translationValues(xOffset, yOffset, 0)
                ..scale(isDrawerOpen ? 0.85 : 1.00)
                ..rotateZ(isDrawerOpen ? -0.087 : 0),
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: isDrawerOpen
                    ? BorderRadius.circular(40)
                    : BorderRadius.circular(0),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 50),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          isDrawerOpen
                              ? GestureDetector(
                            child: Icon(Icons.arrow_back_ios),
                            onTap: () {
                              setState(() {
                                xOffset = 0;
                                yOffset = 0;
                                isDrawerOpen = false;
                              });
                            },
                          )
                              : GestureDetector(
                            child: Icon(Icons.menu),
                            onTap: () {
                              setState(() {
                                xOffset = 290;
                                yOffset = 80;
                                isDrawerOpen = true;
                              });
                            },
                          ),
                          Text(
                            'KHATAWAH',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 23),
                        ],
                      ),
                    ),
                    SizedBox(height: 14),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(height: 5),
                          SmallPhotoSlider(), // Insert the photo slider here
                          SizedBox(height: 20),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value;
                                });
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.search),
                                hintText: 'Search',
                                contentPadding: EdgeInsets.only(left: 15),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          StreamBuilder<List<DocumentSnapshot>>(
                            stream: FirestoreService().getPosts(),
                            // Ensure FirestoreService class is defined or imported
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              if (!snapshot.hasData) {
                                return Text("No data available");
                              }
                              List<DocumentSnapshot> posts = snapshot.data!;
                              return Column(
                                children: posts.map((doc) {
                                  Map<String, dynamic> data =
                                  doc.data() as Map<String, dynamic>;
                                  return FutureBuilder<DocumentSnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(data['userID'])
                                        .get(),
                                    builder: (context, userSnapshot) {
                                      if (userSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      }
                                      if (!userSnapshot.hasData) {
                                        return Text("User data not available");
                                      }
                                      Map<String, dynamic> userData =
                                      userSnapshot.data!.data()
                                      as Map<String, dynamic>;
                                      return makeSingleFeed(
                                          FeedData(
                                            userName: userData['FullName'] ??
                                                'Unknown User',
                                            feedTime: DateFormat('hh:mm a')
                                                .format((data['timestamp']
                                            as Timestamp)
                                                .toDate()),
                                            feedText: data['text'] ??
                                                'No text provided',
                                            feedUrl: data['locationURL'] ?? '',
                                            profilePictureUrl:
                                            data['profilePictureUrl'] ?? '',
                                            likeCount: data['likes'] ?? 0,
                                            commentCount: data['comments'] ?? 0,
                                            isLiked: false,
                                            isSaved: false,
                                            imageUrl: data['imageUrl'],
                                            postId: doc.id,
                                            userId: data['userID'],
                                          ),
                                          0);
                                    },
                                  );
                                }).toList(),
                              );
                            },
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey[600],
        elevation: 10.0,
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return Dialog(
                insetPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.grey[100]!, Colors.grey[300]!],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: double.infinity,
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.7,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.grey),
                            ),
                            Text(
                              'Create Post',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .fontFamily,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                if (feedTextController.text.isNotEmpty &&
                                    feedUrlController.text.isNotEmpty) {
                                  addNewPost(feedTextController.text,
                                      feedUrlController.text, _image);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Please fill in all fields except the image.')));
                                }
                              },
                              child: const Text('POST',
                                  style: TextStyle(color: Colors.blue)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: feedTextController,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            hintText: "What's on your mind...",
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.text_fields),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: feedUrlController,
                          decoration: const InputDecoration(
                            hintText: "Feed URL",
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.link),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () async {
                                final picker = ImagePicker();
                                final pickedFile = await picker.pickImage(
                                    source: ImageSource.gallery);
                                setState(() {
                                  if (pickedFile != null) {
                                    _image = File(pickedFile.path);
                                  } else {
                                    print('No image selected.');
                                  }
                                });
                              },
                              icon: Icon(Icons.image),
                            ),
                            const SizedBox(width: 7),
                            TextButton(
                              onPressed: () async {
                                final picker = ImagePicker();
                                final pickedFile = await picker.pickImage(
                                    source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  setState(() {
                                    _image = File(pickedFile.path);
                                  });
                                } else {
                                  print('No image selected.');
                                }
                              },
                              child: Text(
                                "Add Photo",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      home: HomeScreen(),
    );
  }
}
