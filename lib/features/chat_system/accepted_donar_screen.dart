import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../data/repositories/authentication/authentication_repository.dart';

class AcceptedDonorScreen extends StatefulWidget {
  const AcceptedDonorScreen({super.key});

  @override
  State<AcceptedDonorScreen> createState() => _AcceptedDonorScreenState();
}

class _AcceptedDonorScreenState extends State<AcceptedDonorScreen> {
  // Function to initiate or open chat room
  Future<void> openOrCreateChatRoom(
      String currentUserId, String requesterId) async {
    // Sort the IDs to create a unique chat room ID
    List<String> userIds = [currentUserId, requesterId];
    userIds.sort(); // Ensures the ID is consistent regardless of user order
    String chatRoomId = "${userIds[0]}_${userIds[1]}";

    // Check if the chat room exists
    DocumentSnapshot chatRoomSnapshot = await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .get();

    if (!chatRoomSnapshot.exists) {
      // If the chat room does not exist, create it
      await FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(chatRoomId)
          .set({
        'participants': userIds,
        'timestamp': FieldValue.serverTimestamp(),
        // Additional metadata as needed
      });
    }

    Get.snackbar(
      'Success',
      'You have accepted the blood donation request.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Function to delete the accepted blood request
  Future<void> deleteBloodRequest() async {
    try {
      // Delete the blood request document from Firestore

      await FirebaseFirestore.instance
          .collection('blood_requests')
          .where(
            'acceptedBy',
            isEqualTo: AuthenticationRepository().authUser?.uid,
          )
          .get()
          .then((snapshot) async {
        for (var doc in snapshot.docs) {
          await FirebaseFirestore.instance
              .collection('blood_requests')
              .doc(doc.id)
              .delete();
        }
      });

      Get.snackbar(
        'Success',
        'Blood request has been deleted.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete blood request: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Blood Requests',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 8,
          ),
          child: Container(
            decoration: const BoxDecoration(),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('blood_requests')
                  .where(
                    'acceptedBy',
                    isEqualTo: AuthenticationRepository().authUser?.uid,
                  )
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  );
                }

                // Instead of a ListView inside another ListView,
                return Column(
                  children: snapshot.data!.docs.map((document) {
                    DateTime dateTime = document['timestamp'].toDate();
                    String formattedDate =
                        DateFormat("dd MMMM yyyy").format(dateTime);
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: document['gotDonor'] == 'true'
                              ? Colors.green[100]
                              : Colors.red[100],
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.bloodtype,
                            color: document['gotDonor'] == 'true'
                                ? Colors.green
                                : Colors.red,
                          ),
                          title: Text(document['name'],
                              style: const TextStyle(color: Colors.red)),
                          trailing: Text(
                            '${document['blood_group']}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(formattedDate),
                          tileColor: Colors.red[50],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          onLongPress: () {
                            debugPrint("Long press detected");

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirm Deletion'),
                                  content: const Text(
                                    'Do you want to delete this request?',
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        deleteBloodRequest();
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onTap: () {
                            debugPrint("Do you want to chat");
                            openOrCreateChatRoom(
                              document['acceptedBy'],
                              document['currentId'],
                            );
                          },
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ));
  }
}
