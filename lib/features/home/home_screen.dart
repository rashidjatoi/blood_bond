import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../user_blood_request.dart';
import 'add_patient_blood_requests.dart';
import 'all_user_blood_request_show.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> imageList = [
    'assets/images/donor2.png',
    'assets/images/donor2.png',
    'assets/images/donor2.png',
  ];
  String userType = '';
  @override
  void initState() {
    super.initState();
    _fetchUserType();
  }

  Future<void> _fetchUserType() async {
    DocumentReference userRef = FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser?.uid);

    userRef.get().then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        setState(() {
          userType = snapshot['userType'] ?? '';
        });
      } else {
        log("User not found!");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Blood Bond',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: CarouselSlider(
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                enlargeCenterPage: false,
                viewportFraction: 1.0,
              ),
              items: imageList.map((imagePath) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Blood Patients"),
                InkWell(
                  onTap: () {
                    Get.to(
                      () => const AllUserBloodReuestScreen(),
                    );
                  },
                  child: const Text(
                    "See more",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
          const Expanded(
            child: UserBloodReuestScreen(),
          )
        ],
      ),
      floatingActionButton: userType == 'patient'
          ? FloatingActionButton(
              onPressed: () {
                Get.to(() => const AddPatientBloodRequests());
              },
              backgroundColor: Colors.red,
              shape: const CircleBorder(),
              child: const Icon(
                Iconsax.add,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}
