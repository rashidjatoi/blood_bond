import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BloodDonationSwitch extends StatefulWidget {
  const BloodDonationSwitch({super.key});

  @override
  State<BloodDonationSwitch> createState() => _BloodDonationSwitchState();
}

class _BloodDonationSwitchState extends State<BloodDonationSwitch> {
  bool isAvailable = false;
  String userType = '';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _getAvailabilityStatus();
  }

  Future<void> _getAvailabilityStatus() async {
    try {
      // Access the document for the specific user
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();

      if (userSnapshot.exists) {
        setState(() {
          // Assuming `isAvailable` is stored as a boolean in Firestore
          isAvailable = userSnapshot['isAvailable'] == 'true';
          userType = userSnapshot['userType'];
          loading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }
  }

  Future<void> _toggleAvailability(bool newValue) async {
    try {
      await FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({
        'isAvailable': newValue ? 'true' : 'false',
      });

      setState(() {
        isAvailable = newValue;
      });
    } catch (e) {
      debugPrint("Error updating availability: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Available for Donation",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Switch(
                  activeColor: Colors.black,
                  value: isAvailable,
                  onChanged: (newValue) {
                    _toggleAvailability(newValue);
                  },
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Available for Donation",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Switch(
                  activeColor: Colors.green,
                  value: isAvailable,
                  onChanged: (newValue) {
                    _toggleAvailability(newValue);
                  },
                ),
              ],
            ),
          );
  }
}
