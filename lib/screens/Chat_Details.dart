import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String myUserID;

  const ChatScreen({Key? key, required this.myUserID}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String searchQuery = '';
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: isSearching
            ? TextField(
          onChanged: (value) {
            setState(() {
              searchQuery = value.toLowerCase();
            });
          },
          decoration: InputDecoration(
            hintText: 'Search users...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
        )
            : const Text('Chats'),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) searchQuery = '';
              });
            },
          ),
        ],
        backgroundColor: const Color(0xFF416C77),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error loading users: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          var documents = snapshot.data!.docs;
          var filteredDocs = documents.where((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return data['fullName'].toLowerCase().contains(searchQuery);
          }).toList();

          return ListView.builder(
            itemCount: filteredDocs.length,
            itemBuilder: (context, index) {
              var data = filteredDocs[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: data['profilePictureUrl'] != null
                      ? NetworkImage(data['profilePictureUrl'])
                      : const AssetImage("assets/default_user.png") as ImageProvider,
                ),
                title: Text(data['fullName']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatDetailsScreen(
                        userName: data['fullName'],
                        profilePictureUrl: data['profilePictureUrl'],
                        myUserID: widget.myUserID,
                        otherUserID: data['userID'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ChatDetailsScreen extends StatefulWidget {
  final String userName;
  final String? profilePictureUrl;
  final String myUserID;
  final String otherUserID;

  const ChatDetailsScreen({
    Key? key,
    required this.userName,
    this.profilePictureUrl,
    required this.myUserID,
    required this.otherUserID,
  }) : super(key: key);

  @override
  _ChatDetailsScreenState createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  String chatID = '';
  String searchQuery = '';
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    chatID = generateChatId(widget.myUserID, widget.otherUserID);
  }

  String generateChatId(String userId1, String userId2) {
    return userId1.compareTo(userId2) < 0
        ? "$userId1-$userId2"
        : "$userId2-$userId1";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: isSearching
            ? TextField(
          onChanged: (value) {
            setState(() {
              searchQuery = value.toLowerCase();
            });
          },
          decoration: InputDecoration(
            hintText: 'Search chats...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
        )
            : Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: widget.profilePictureUrl != null
                  ? NetworkImage(widget.profilePictureUrl!)
                  : const AssetImage("assets/default_user.png")
              as ImageProvider,
            ),
            const SizedBox(width: 10),
            Text(
              widget.userName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) searchQuery = '';
              });
            },
          ),
        ],
        backgroundColor: const Color(0xFF416C77),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatID)
                  .collection('messages')
                  .orderBy('dateTime', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error loading messages: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                var documents = snapshot.data!.docs;
                var filteredDocs = documents.where((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  return data['text'].toLowerCase().contains(searchQuery);
                }).toList();

                return ListView.builder(
                  reverse: true,
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    var data = filteredDocs[index].data() as Map<String, dynamic>;
                    bool isMe = data['senderId'] == widget.myUserID;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: Align(
                        alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMe
                                ? Colors.deepPurple[100]
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(data['text'],
                              style: const TextStyle(fontSize: 16)),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextComposer(myUserID: widget.myUserID, chatID: chatID),
          ),
        ],
      ),
    );
  }
}

class TextComposer extends StatefulWidget {
  final String myUserID;
  final String chatID;

  const TextComposer({Key? key, required this.myUserID, required this.chatID})
      : super(key: key);

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  final TextEditingController _controller = TextEditingController();

  void _handleSubmitted(String text) {
    if (text.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatID)
          .collection('messages')
          .add({
        'senderId': widget.myUserID,
        'text': text,
        'dateTime': DateTime.now().toIso8601String(),
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.grey[200],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Send a message",
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                ),
                onSubmitted: _handleSubmitted,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () => _handleSubmitted(_controller.text),
          ),
        ],
      ),
    );
  }
}
