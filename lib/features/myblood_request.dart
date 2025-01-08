import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../data/repositories/authentication/authentication_repository.dart';

class MyBloodReuestScreen extends StatefulWidget {
  const MyBloodReuestScreen({super.key});

  @override
  State<MyBloodReuestScreen> createState() => _MyBloodReuestScreenState();
}

class _MyBloodReuestScreenState extends State<MyBloodReuestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Blood Requests',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('blood_requests')
            .where(
              'currentId',
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

          return ListView(
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
                    onTap: document['gotDonor'] == 'true'
                        ? () {
                            Get.snackbar(
                              'Message',
                              'Thank you, patient got the donor already!',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          }
                        : () {
                            // Show the bottom sheet with additional details
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
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name: ${document['name']}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                        'Blood Group: ${document['blood_group']}'),
                                    Text('Location: ${document['location']}'),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            'Contact: ${document['contact_number']}'),
                                        IconButton(
                                          icon: const Icon(Icons.copy,
                                              color: Colors.red),
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(
                                                text: document[
                                                    'contact_number']));
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
                                    if (document['additional_contacts'] !=
                                            null &&
                                        document['additional_contacts']
                                            .isNotEmpty)
                                      Column(
                                        children: [
                                          const SizedBox(height: 10),
                                          Text(
                                              'Additional Contacts: ${document['additional_contacts']}'),
                                        ],
                                      ),
                                    const SizedBox(height: 10),
                                    Text('Status: ${document['status']}'),
                                  ],
                                ),
                              ),
                            );
                          },
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.red,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
