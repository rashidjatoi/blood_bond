import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import '/features/authentication/models/user_model.dart';
import '/utils/exceptions/firebase_exceptions.dart';
import '/utils/exceptions/format_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../features/authentication/models/user_perticular_model.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

/// Repository class for user-related operations
class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  /// Function to save user data to Firestore
  Future<void> saveUserRecord(UserModel user) async {
    try {
      await FirebaseFirestore.instance
          .collection("User")
          .doc(user.id)
          .set(user.toJson());
    } on FirebaseException catch (e) {
      throw EFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const EFormatException();
    } on PlatformException catch (e) {
      throw EPlatformException(e.code).message;
    } catch (e) {
      throw 'Some thing went wrong. Please try again';
    }
  }

  /// Function to fetch user details based on user ID
  Future<UserModel> fetchUserDetails() async {
    try {
      final documentSnapshot = await FirebaseFirestore.instance
          .collection("User")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } on FirebaseException catch (e) {
      throw EFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const EFormatException();
    } on PlatformException catch (e) {
      throw EPlatformException(e.code).message;
    } catch (e) {
      throw 'Some thing went wrong. Please try again';
    }
  }

  /// Function to fetch user details based on user ID
  Future<UserPerticularModel> fetchPerticulatUserDetails(String userId) async {
    try {
      final documentSnapshot =
          await FirebaseFirestore.instance.collection("User").doc(userId).get();
      if (documentSnapshot.exists) {
        return UserPerticularModel.fromSnapshot(documentSnapshot);
      } else {
        return UserPerticularModel.empty();
      }
    } on FirebaseException catch (e) {
      throw EFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const EFormatException();
    } on PlatformException catch (e) {
      throw EPlatformException(e.code).message;
    } catch (e) {
      throw 'Some thing went wrong. Please try again';
    }
  }

  /// Function to update user data in Firestore
  Future<void> updateUserDetails(UserModel updateUser) async {
    try {
      await FirebaseFirestore.instance
          .collection("User")
          .doc(updateUser.id)
          .update(updateUser.toJson());
    } on FirebaseException catch (e) {
      throw EFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const EFormatException();
    } on PlatformException catch (e) {
      throw EPlatformException(e.code).message;
    } catch (e) {
      throw 'Some thing went wrong. Please try again';
    }
  }

  /// Update any field in specific User Collection
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await FirebaseFirestore.instance
          .collection("User")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update(json);
    } on FirebaseException catch (e) {
      throw EFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const EFormatException();
    } on PlatformException catch (e) {
      throw EPlatformException(e.code).message;
    } catch (e) {
      throw 'Some thing went wrong. Please try again';
    }
  }

  /// Function to remove user data from Firestore
  Future<void> removeUserRecord(String userId) async {
    try {
      await FirebaseFirestore.instance.collection("User").doc(userId).delete();
    } on FirebaseException catch (e) {
      throw EFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const EFormatException();
    } on PlatformException catch (e) {
      throw EPlatformException(e.code).message;
    } catch (e) {
      throw 'Some thing went wrong. Please try again';
    }
  }

  /// Upload any image
  Future<String> uploadImage(String path, XFile image) async {
    try {
      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      throw EFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const EFormatException();
    } on PlatformException catch (e) {
      throw EPlatformException(e.code).message;
    } catch (e) {
      throw 'Some thing went wrong. Please try again';
    }
  }
}
