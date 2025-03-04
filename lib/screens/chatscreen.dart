import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chat_details.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatUser> chatUsers = [];
  List<ChatUser> filteredUsers = [];
  bool isLoading = false;
  bool isSearching = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      setState(() => isLoading = true);
      var querySnapshot = await FirebaseFirestore.instance.collection('Users').get();
      var users = querySnapshot.docs.map((doc) => ChatUser.fromDocument(doc)).toList();
      setState(() {
        chatUsers = users;
        filteredUsers = users;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void filterUsers(String query) {
    final filtered = chatUsers.where((user) {
      final userNameLower = user.userName.toLowerCase();
      final searchLower = query.toLowerCase();
      return userNameLower.contains(searchLower);
    }).toList();

    setState(() {
      searchQuery = query;
      filteredUsers = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
          onChanged: (value) {
            filterUsers(value);
          },
          decoration: InputDecoration(
            hintText: 'Search users...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
        )
            : const Text('Chat Screen', style: TextStyle(color: Colors.white)),
        elevation: 0,
        backgroundColor: const Color(0xFF416C77),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchQuery = '';
                  filteredUsers = chatUsers;
                }
              });
            },
          ),
        ],
        shadowColor: Colors.indigo[300],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.indigo))
          : filteredUsers.isEmpty
          ? const Center(child: Text("No users found", style: TextStyle(fontSize: 18, color: Colors.grey)))
          : AnimationLimiter(
        child: ListView.builder(
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 30.0,
                child: FadeInAnimation(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.indigo.shade50,
                      backgroundImage: NetworkImage(filteredUsers[index].profilePictureUrl),
                    ),
                    title: Text(
                      filteredUsers[index].userName,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    subtitle: Text('Tap to chat', style: TextStyle(color: Colors.indigo[300])),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatDetailsScreen(
                            userName: filteredUsers[index].userName,
                            profilePictureUrl: filteredUsers[index].profilePictureUrl,
                            myUserID: FirebaseAuth.instance.currentUser!.uid,
                            otherUserID: filteredUsers[index].userID,
                          ),
                        ),
                      );
                    },
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ChatUser {
  final String userName;
  final String profilePictureUrl;
  final String userID;

  ChatUser({required this.userName, required this.profilePictureUrl, required this.userID});

  factory ChatUser.fromDocument(DocumentSnapshot doc) {
    return ChatUser(
      userName: doc['FullName'],
      profilePictureUrl: doc['Profile Image'],
      userID: doc.id,
    );
  }
}
