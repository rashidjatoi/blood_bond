import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../personalization/controllers/user_controller.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({super.key});

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final controller = UserController.instance;

  String searchQuery = "";
  TextEditingController searchController = TextEditingController();

  Stream<QuerySnapshot> _getUsersStream() {
    if (searchQuery.isEmpty) {
      return FirebaseFirestore.instance.collection('User').snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('User')
          .where('bloodType', isEqualTo: searchQuery)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Users',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by Blood Type',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.trim();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getUsersStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var users = snapshot.data!.docs;

                if (users.isEmpty) {
                  return const Center(
                    child: Text('No users found'),
                  );
                }

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var user = users[index];

                    if (user['isAvailable'] == 'false') {
                      return Container();
                    }

                    if (user['userType'] == controller.user.value.userType) {
                      return Container();
                    }

                    return InkWell(
                      child: Container(
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
                          margin: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          child: Column(
                            children: [
                              // Role Label: Donor or Patient
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: user['userType'] == 'donor'
                                        ? Colors.green
                                        : Colors.blue,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    user['userType'] == 'donor'
                                        ? 'Donor'
                                        : 'Patient',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              // Row for Avatar, Name, and Blood Type
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.grey[300],
                                        radius: 25,
                                        child: Icon(
                                          user['userType'] == 'donor'
                                              ? Icons.volunteer_activism
                                              : Icons.person,
                                          color: user['userType'] == 'donor'
                                              ? Colors.green
                                              : Colors.blue,
                                          size: 35,
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${user['FirstName']} ${user['LastName']}',
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            '${user['city']}',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  // Trailing Blood Type and Availability
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Blood Type: ${user['bloodType']}',
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            'Status: ${user['isAvailable'] == 'true' ? 'Available' : 'Unavailable'}',
                                            style: TextStyle(
                                              color:
                                                  user['isAvailable'] == 'true'
                                                      ? Colors.green
                                                      : Colors.red,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      // Additional Info (optional)
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.grey[600],
                                        size: 25,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              title: Text(
                                user['userType'] == "donor"
                                    ? 'Donor Details'
                                    : 'Patient Details',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customListTile(
                                      title: 'Name',
                                      value:
                                          '${user['FirstName']} ${user['LastName']}',
                                    ),
                                    customListTile(
                                      title: 'Email',
                                      value: '${user['Email']}',
                                    ),
                                    customListTile(
                                      title: 'Phone',
                                      value: '${user['PhoneNumber']}',
                                    ),
                                    customListTile(
                                      title: 'Username',
                                      value: '${user['UserName']}',
                                    ),
                                    customListTile(
                                      title: 'Blood Type',
                                      value: '${user['bloodType']}',
                                    ),
                                    user['userType'] == "donor"
                                        ? customListTile(
                                            title: 'Last Donation',
                                            value:
                                                '${user['lastDonationDate']}',
                                          )
                                        : customListTile(
                                            title: 'Disability',
                                            value: '${user['bloodDisability']}',
                                          ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Contact: ${user['PhoneNumber']}'),
                                        IconButton(
                                          icon: const Icon(Icons.copy,
                                              color: Colors.red),
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(
                                                text: user['PhoneNumber']));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Phone number copied to clipboard'),
                                                backgroundColor: Colors.green,
                                              ),
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
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
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
