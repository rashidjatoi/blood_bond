// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../common/widgets/images/e_circular_image.dart';
import '../../data/repositories/authentication/authentication_repository.dart';
import '../../utils/constants/image_strings.dart';

class ChatRoomUserAndDonor extends StatefulWidget {
  const ChatRoomUserAndDonor({
    super.key,
  });

  @override
  State<ChatRoomUserAndDonor> createState() => _ChatRoomUserAndDonorState();
}

class _ChatRoomUserAndDonorState extends State<ChatRoomUserAndDonor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chat Rooms",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chatRooms')
            .where('participants',
                arrayContains: AuthenticationRepository().authUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No chats available"),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
            ),
            child: ListView(
              children: snapshot.data!.docs.map((doc) {
                final chatRoomId = doc.id;
                final participants = doc['participants'];
                final otherUserId = participants.firstWhere(
                    (id) => id != AuthenticationRepository().authUser?.uid);

                // Fetch the other user’s details (name and email) from the User collection
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('User')
                      .doc(otherUserId)
                      .get(),
                  builder: (context, userSnapshot) {
                    if (!userSnapshot.hasData) {
                      return const Center(
                        child: Text("Loading user info..."),
                      );
                    }

                    // Extracting the user details
                    final userData =
                        userSnapshot.data!.data() as Map<String, dynamic>;
                    final userName = userData['UserName'] ?? 'Unknown User';
                    final userEmail = userData['Email'] ?? 'Unknown Email';
                    final userProfile = userData['ProfilePicture'] ?? '';

                    final image =
                        userProfile.isEmpty ? EImages.user : userProfile;

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: ECircularImage(
                          backgroundColor: Colors.white,
                          isNetworkImage: userProfile.isNotEmpty ? true : false,
                          image: image,
                          padding: 0,
                          width: 50,
                          height: 50,
                        ),
                        title: Text("$userName"),
                        subtitle: Text("$userEmail"),
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Delete Chat"),
                                content: const Text(
                                    "Are you sure you want to delete this chat?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      try {
                                        // Delete the chat room document from Firestore
                                        await FirebaseFirestore.instance
                                            .collection('chatRooms')
                                            .doc(chatRoomId)
                                            .delete();

                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Chat deleted successfully"),
                                          ),
                                        );
                                      } catch (e) {
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content:
                                                Text("Error deleting chat: $e"),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text("Delete"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                chatRoomId: chatRoomId,
                                currentUserId:
                                    AuthenticationRepository().authUser?.uid ??
                                        '',
                                otherUserId: otherUserId,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  final String chatRoomId;
  final String currentUserId;
  final String otherUserId;

  const ChatScreen({
    super.key,
    required this.chatRoomId,
    required this.currentUserId,
    required this.otherUserId,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(color: Colors.white),
        title: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('User')
              .doc(otherUserId)
              .get(),
          builder: (context, userSnapshot) {
            if (!userSnapshot.hasData) return const Text("Chat");
            final userData = userSnapshot.data!.data() as Map<String, dynamic>;
            return Text(
              "${userData['UserName']}",
              style: const TextStyle(color: Colors.white),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chatRooms')
                  .doc(chatRoomId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData = messages[index];
                    final isCurrentUser =
                        messageData['senderId'] == currentUserId;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Align(
                        alignment: isCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: isCurrentUser ? Colors.blue : Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            messageData['message'],
                            style: const TextStyle(color: Colors.white),
                          ),
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
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Enter message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (messageController.text.isNotEmpty) {
                      FirebaseFirestore.instance
                          .collection('chatRooms')
                          .doc(chatRoomId)
                          .collection('messages')
                          .add({
                        'senderId': currentUserId,
                        'message': messageController.text,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                      messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
