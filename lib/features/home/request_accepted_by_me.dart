// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/utils/popups/loaders.dart';
import '../../data/repositories/authentication/authentication_repository.dart';

class RequestAcceptedByMeScreen extends StatefulWidget {
  const RequestAcceptedByMeScreen({super.key});

  @override
  State<RequestAcceptedByMeScreen> createState() =>
      _RequestAcceptedByMeScreenState();
}

class _RequestAcceptedByMeScreenState extends State<RequestAcceptedByMeScreen> {
  Future<void> showDeleteConfirmationDialog(String documentId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this request?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteRequest(documentId);
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDataDialog({
    required BuildContext context,
    required String bloodGroup,
    required String contactNumber,
    required String hospital,
    required String location,
    required String name,
    required Timestamp timeData,
  }) async {
    final DateTime parsedTime = timeData.toDate();

    final String formattedTime =
        DateFormat('EEEE, MMM d, yyyy hh:mm a').format(parsedTime);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Request Details"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name: $name",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("Blood Group: $bloodGroup"),
                const SizedBox(height: 8),
                Text("Contact: $contactNumber"),
                const SizedBox(height: 8),
                Text("Hospital: $hospital"),
                const SizedBox(height: 8),
                Text("Location: $location"),
                const SizedBox(height: 8),
                Text("Time: $formattedTime"),
              ],
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Colors.red,
                  ),
                  side: WidgetStatePropertyAll(
                    BorderSide(
                      color: Colors.red,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Close"),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteRequest(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('blood_requests')
          .doc(documentId)
          .delete();

      ELoaders.successSnackBar(
        title: 'Congrats',
        message: 'Request deleted successfully',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete request: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Blood Requests Accepted By Me',
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
          Expanded(
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

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No Requests Found"),
                  );
                }

                return ListView(
                  children: snapshot.data!.docs.map((document) {
                    DateTime dateTime = document['timestamp'] != null
                        ? document['timestamp'].toDate()
                        : DateTime.now();
                    String formattedDate =
                        DateFormat("dd MMMM yyyy").format(dateTime);
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        decoration: BoxDecoration(
                          color: document['gotDonor'] == 'true'
                              ? Colors.green[100]
                              : Colors.red[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {
                            // _showDeleteConfirmationDialog(document.id);
                            _showDataDialog(
                              bloodGroup: document['blood_group'],
                              contactNumber: document['contact_number'],
                              hospital: document['hospital'],
                              location: document['location'],
                              name: document['name'],
                              timeData: document['timestamp'],
                              context: context,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.2),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Hospital",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      '${document['hospital']}',
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color:
                                                document['gotDonor'] == 'true'
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
}
