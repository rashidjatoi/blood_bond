import 'package:cloud_firestore/cloud_firestore.dart';
import '/features/donor/blood_donor_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../data/repositories/authentication/authentication_repository.dart';
import '../personalization/controllers/user_controller.dart';

class AllUserBloodReuestScreen extends StatefulWidget {
  const AllUserBloodReuestScreen({super.key});

  @override
  State<AllUserBloodReuestScreen> createState() =>
      _AllUserBloodReuestScreenState();
}

class _AllUserBloodReuestScreenState extends State<AllUserBloodReuestScreen> {
  final controller = UserController.instance;

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
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "These are the Blood requests submitted by all users",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('requests')
                  .where(
                    'user_id',
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

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No Requests Found"),
                  );
                }

                return ListView(
                  children: snapshot.data!.docs.map((document) {
                    return Padding(
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
                                'currentId',
                                isEqualTo: document['blood_request_user_id'],
                              )
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.red,
                                ),
                              );
                            }

                            String donationKey =
                                document['blood_request_user_id'];
                            // Instead of a ListView inside another ListView,
                            return Column(
                              children: snapshot.data!.docs.map((document) {
                                DateTime dateTime =
                                    document['timestamp'].toDate();
                                String formattedDate =
                                    DateFormat("dd MMMM yyyy").format(dateTime);
                                return InkWell(
                                  onTap: () {
                                    if (controller.user.value.userType ==
                                        'patient') {
                                      showPatientMessage();
                                      return;
                                    }
                                    if (document['gotDonor'] == 'false') {
                                      showDonationDialog(context, donationKey);
                                    } else if (document['currentId'] ==
                                        AuthenticationRepository
                                            .instance.authUser?.uid) {
                                      showDetailsBottomSheet(context, document);
                                    } else {
                                      showDonorAlreadyFoundMessage();
                                    }
                                  },
                                  child: _patientUserDetails(
                                    document,
                                    formattedDate,
                                  ),
                                );
                              }).toList(),
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
        ],
      ),
    );
  }

  Column _patientUserDetails(
      QueryDocumentSnapshot<Object?> document, String formattedDate) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Patient Details",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          document['name'],
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${document['blood_group']}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Location",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${document['location']}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Status",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: document['gotDonor'] == 'true'
                              ? Colors.green
                              : Colors.yellow,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        document['gotDonor'] == 'true'
                            ? "Donor Found"
                            : "Awaiting Donor",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void showDonorAlreadyFoundMessage() {
  Get.snackbar(
    'Message',
    'Thank you, patient got the donor already!',
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.green,
    colorText: Colors.white,
  );
}

void showPatientMessage() {
  Get.snackbar(
    'Notification',
    'Thank you, patient is waiting for the donor!',
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.red,
    colorText: Colors.white,
  );
}

void showDonationDialog(BuildContext context, String donationKey) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Blood Donation'),
        content: const Text('Do you want to donate blood?'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red, width: 2),
                  ),
                  child: const Text(
                    'No',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    updateAllBloodDonation(req: donationKey);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    side: const BorderSide(color: Colors.green, width: 2),
                  ),
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

void showDetailsBottomSheet(
  BuildContext context,
  QueryDocumentSnapshot document,
) {
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customListTile(title: 'Patient Name', value: document['name']),
            customListTile(
                title: 'Blood Group', value: document['blood_group']),
            customListTile(title: 'Location', value: document['location']),
            customListTile(title: 'Status', value: document['status']),
            customListTile(title: 'Got Donor', value: document['gotDonor']),
            customListTile(
              title: 'Donar Details',
              value: 'Click to see Donar Details',
              onTap: () {
                Get.back();
                Get.to(() =>
                    BloodDonorProfileScreen(userId: document['acceptedBy']));
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Contact: ${document['contact_number']}'),
                IconButton(
                  icon: const Icon(Icons.copy, color: Colors.red),
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: document['contact_number']),
                    );
                    Get.snackbar(
                      'Copied',
                      'Phone number copied to clipboard',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> openOrCreateChatRoom(
  String currentUserId,
  String requesterId,
) async {
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

  // Get.snackbar(
  //   'Success',
  //   'You have accepted the blood donation request.',
  //   snackPosition: SnackPosition.TOP,
  //   backgroundColor: Colors.green,
  //   colorText: Colors.white,
  // );
}

void updateAllBloodDonation({required String req}) async {
  final currentUserId = AuthenticationRepository().authUser?.uid;

  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('requests')
      .where('blood_request_user_id', isEqualTo: req)
      .get();

  openOrCreateChatRoom(currentUserId.toString(), req);

  for (var doc in querySnapshot.docs) {
    await FirebaseFirestore.instance.collection('requests').doc(doc.id).update({
      'acceptedBy': currentUserId,
      'isAccepted': 'true',
    });
  }

  QuerySnapshot requestsSnapshot = await FirebaseFirestore.instance
      .collection('blood_requests')
      .where('currentId', isEqualTo: req)
      .get();

  for (var doc in requestsSnapshot.docs) {
    await doc.reference.update({
      'gotDonor': 'true',
      'acceptedBy': currentUserId,
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

Widget customListTile({
  required String title,
  required String value,
  void Function()? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4), // Space between title and value
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    ),
  );
}
