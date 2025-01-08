import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/repositories/authentication/authentication_repository.dart';

class AddPatientBloodRequests extends StatefulWidget {
  const AddPatientBloodRequests({super.key});

  @override
  State<AddPatientBloodRequests> createState() =>
      _AddPatientBloodRequestsState();
}

class _AddPatientBloodRequestsState extends State<AddPatientBloodRequests> {
  // Controllers for each input field
  final nameController = TextEditingController();
  final bloodGroupController = TextEditingController();
  final statusController = TextEditingController();
  final locationController = TextEditingController();
  final contactNumberController = TextEditingController();
  final hospitalController = TextEditingController();
  final selectedCity = ''.obs;
  final selectedStatus = ''.obs;

  bool isLoading = false;

  void _addBloodRequest() async {
    isLoading = true;

    setState(() {});
    final name = nameController.text;
    final bloodGroup = bloodGroupController.text;
    final contactNumber = contactNumberController.text;
    final hospital = hospitalController.text;

    // Check if all required fields are filled
    if (name.isNotEmpty &&
        bloodGroup.isNotEmpty &&
        selectedStatus.value.isNotEmpty &&
        selectedCity.isNotEmpty &&
        contactNumber.isNotEmpty &&
        hospital.isNotEmpty) {
      try {
        // Add data to Firestore
        await FirebaseFirestore.instance.collection('blood_requests').add({
          'name': name,
          'blood_group': bloodGroup,
          'status': selectedStatus.value,
          'location': selectedCity.value,
          'contact_number': contactNumber,
          'hospital': hospital,
          'timestamp': FieldValue.serverTimestamp(),
          'gotDonor': 'false',
          'acceptedBy': '',
          'currentId': AuthenticationRepository().authUser?.uid,
        });

        _checkAndSaveMatchingCityUsers(selectedCity.value, bloodGroup);

        isLoading = false;

        setState(() {});
        Get.back();

        // Get.back();
        // Get.snackbar(
        //   'Success',
        //   'Blood request added successfully',
        //   snackPosition: SnackPosition.TOP,
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // );

        // Clear the controllers after submission
        nameController.clear();
        bloodGroupController.clear();
        statusController.clear();
        locationController.clear();
        contactNumberController.clear();
        hospitalController.clear();
      } catch (error) {
        Get.snackbar(
          'Error',
          'Failed to add blood request: $error',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

        isLoading = false;

        setState(() {});
      }
    } else {
      Get.snackbar(
        'Error',
        'All fields are required',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      isLoading = false;

      setState(() {});
    }
  }

  // Future<void> _checkAndSaveMatchingCityUsers(
  //   String city,
  //   String bloodType,
  // ) async {
  //   try {
  //     String currentUserId = AuthenticationRepository().authUser?.uid ?? '';
  //     // Query Firestore to get users in the same city
  //     QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
  //         .collection('User')
  //         .where('city', isEqualTo: city)
  //         .get();

  //     if (usersSnapshot.docs.isNotEmpty) {
  //       for (var userDoc in usersSnapshot.docs) {
  //         String userId = userDoc.id;

  //         // Exclude the current user
  //         if (userId != currentUserId) {
  //           await FirebaseFirestore.instance.collection('requests').add({
  //             'user_id': userId,
  //             'blood_request_user_id': AuthenticationRepository().authUser?.uid,
  //             'requestUserEmail': AuthenticationRepository().authUser?.email,
  //             'location': city,
  //             'isAccepted': 'false',
  //             'acceptedBy': '',
  //             'timestamp': FieldValue.serverTimestamp(),
  //           });
  //         }
  //       }
  //     } else {
  //       Get.snackbar(
  //         'No Match',
  //         'No users found in the same city.',
  //         snackPosition: SnackPosition.TOP,
  //         backgroundColor: Colors.red,
  //         colorText: Colors.white,
  //       );
  //     }
  //   } catch (error) {
  //     log("Error checking users in the same city: $error");
  //     Get.snackbar(
  //       'Error',
  //       'An error occurred while processing your request.',
  //       snackPosition: SnackPosition.TOP,
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //   }
  // }

  Future<void> _checkAndSaveMatchingCityUsers(
    String city,
    String bloodType,
  ) async {
    try {
      // Ensure city and bloodType are provided
      if (city.isEmpty || bloodType.isEmpty) {
        Get.snackbar(
          'Error',
          'City and Blood Type are required.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      String currentUserId = AuthenticationRepository().authUser?.uid ?? '';

      // Helper function to get compatible blood groups
      List<String> _getCompatibleBloodGroups(String type) {
        switch (type) {
          case 'A+':
            return ['A+', 'A-', 'O+', 'O-'];
          case 'A-':
            return ['A-', 'O-'];
          case 'B+':
            return ['B+', 'B-', 'O+', 'O-'];
          case 'B-':
            return ['B-', 'O-'];
          case 'AB+':
            return ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
          case 'AB-':
            return ['A-', 'B-', 'AB-', 'O-'];
          case 'O+':
            return ['O+', 'O-'];
          case 'O-':
            return ['O-'];
          default:
            return [];
        }
      }

      // Get compatible blood groups for the given blood type
      List<String> compatibleBloodGroups = _getCompatibleBloodGroups(bloodType);

      // Query Firestore to get users in the same city with compatible blood groups
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .where('city', isEqualTo: city)
          .where('bloodType', whereIn: compatibleBloodGroups)
          .get();

      if (usersSnapshot.docs.isNotEmpty) {
        for (var userDoc in usersSnapshot.docs) {
          String userId = userDoc.id;

          // Exclude the current user
          if (userId != currentUserId) {
            await FirebaseFirestore.instance.collection('requests').add({
              'user_id': userId,
              'blood_request_user_id': currentUserId,
              'requestUserEmail': AuthenticationRepository().authUser?.email,
              'location': city,
              'isAccepted': 'false',
              'acceptedBy': '',
              'timestamp': FieldValue.serverTimestamp(),
            });
          }
        }

        Get.snackbar(
          'Success',
          'Blood request added successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'No Match',
          'No users found in the same city with a compatible blood group.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (error) {
      log("Error checking users in the same city: $error");
      Get.snackbar(
        'Error',
        'An error occurred while processing your request.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create New Request',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Get.to(() => const MyBloodRequestScreen());
        //     },
        //     icon: const Icon(
        //       Iconsax.eye,
        //       color: Colors.white,
        //     ),
        //   )
        // ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // SIZEDBOX
              const SizedBox(height: 10),
              // NAME
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Patient Name'),
              ),

              // SIZEDBOX
              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: bloodGroupController.text.isEmpty
                    ? null
                    : bloodGroupController.text,
                onChanged: (newValue) {
                  bloodGroupController.text = newValue!;
                },
                items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                    .map((String bloodType) {
                  return DropdownMenuItem<String>(
                    value: bloodType,
                    child: Text(bloodType),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: "Patient Blood Type",
                ),
              ),

              // SIZEDBOX
              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: statusController.text.isEmpty
                    ? null
                    : statusController.text,
                onChanged: (newValue) {
                  selectedStatus.value = newValue!;
                },
                items: ['Single', 'Married'].map((String bloodType) {
                  return DropdownMenuItem<String>(
                    value: bloodType,
                    child: Text(bloodType),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: "Patient Status",
                ),
              ),

              // SIZEDBOX
              const SizedBox(height: 10),

              /// City Dropdown
              DropdownButtonFormField<String>(
                value: selectedCity.isEmpty ? null : selectedCity.value,
                onChanged: (String? newValue) {
                  selectedCity.value = newValue!;
                },
                items: [
                  'Karachi',
                  'Hyderabad',
                  'Sukkur',
                  'Larkana',
                  'Nawabshah',
                  'Mirpur Khas',
                  'Jamshoro',
                  'Khairpur',
                  'Dadu',
                  'Shikarpur',
                  'Jacobabad',
                  'Ghotki',
                  'Tando Adam',
                  'Tando Allahyar',
                  'Matiari',
                  'Badin',
                  'Umerkot',
                  'Sanghar',
                  'Thatta',
                  'Kandhkot',
                  'Qambar Shahdadkot',
                  'Kashmore',
                  'Hala',
                  'Sehwan',
                  'Shahdadpur',
                  'Kotri',
                  'Mithi',
                  'Tharparkar',
                  'Sujawal',
                  'Tando Muhammad Khan',
                ].map((String city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: "City",
                ),
              ),

              // SIZEDBOX
              const SizedBox(height: 10),

              // CONTACT
              TextField(
                controller: hospitalController,
                decoration: const InputDecoration(labelText: 'Hospital'),
                keyboardType: TextInputType.text,
              ),

              // SIZEDBOX
              const SizedBox(height: 10),

              // CONTACT
              TextField(
                controller: contactNumberController,
                decoration: const InputDecoration(labelText: 'Contact Number'),
                keyboardType: TextInputType.phone,
              ),

              // SIZEDBOX
              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    side: MaterialStateProperty.all<BorderSide>(
                      const BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                  onPressed: _addBloodRequest,
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          ),
                        )
                      : const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
