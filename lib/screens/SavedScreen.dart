import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../modles/firestore_service.dart';

class SavedScreen extends StatefulWidget {
  @override
  _SavedScreenState createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final String? _userID = FirebaseAuth.instance.currentUser?.uid;

  // Function to delete a post
  Future<void> _deletePost(String postId) async {
    try {
      await _firestoreService.deletePost(postId);
    } catch (e) {
      print("Error deleting post: $e");
      // Handle error if necessary
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_userID == null) {
      return Scaffold(
        appBar: AppBar(title: Text(" My Posts")),
        body: Center(child: Text("You are not logged in")),
      );
    }

    return Scaffold(
      appBar:AppBar(
        title: Text(' My Posts', style: TextStyle(color: Colors.white)),
        elevation: 0,
        backgroundColor: Color(0xFF416C77),
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[

        ],
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: _firestoreService.getUserPosts(_userID!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error occurred: ${snapshot.error.toString()}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("You have no posts"));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var post = snapshot.data![index].data() as Map<String, dynamic>;
              String postId = snapshot.data![index].id; // Get the post ID

              return GestureDetector(
                onTap: () {
                  // Add onTap action if needed
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500), // Set animation duration
                  curve: Curves.easeInOut, // Use easeInOut curve for smoother animation
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      post['imageUrl'] != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: Image.network(
                          post['imageUrl'],
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      )
                          : SizedBox.shrink(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post['text'] ?? "No Content",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Posted on " + (post['timestamp'] as Timestamp).toDate().toString(),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.grey, // Set delete icon color
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Confirm"),
                                    content: Text("Are you sure you want to delete this post?"),
                                    actions: [
                                      TextButton(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text("Delete"),
                                        onPressed: () {
                                          _deletePost(postId);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

    );
  }
}
