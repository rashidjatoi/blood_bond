import 'package:cloud_firestore/cloud_firestore.dart';
import '/utils/formatters/formatter.dart';

/// Model class represent model data
class UserModel {
  // keep those values which you do not want to update
  final String id;
  String firstName;
  String lastName;
  final String userName;
  final String email;
  String phoneNumber;
  String profilePicture;
  String bloodType;
  String isAvailable;
  String deviceToken;
  String userType;
  String lastDonationDate;
  String bloodDisability;
  String city;

  /// Constructor for UserModel
  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    required this.bloodType,
    this.isAvailable = 'true',
    this.deviceToken = '',
    this.userType = 'donar',
    this.lastDonationDate = '',
    this.bloodDisability = '',
    this.city = '',
  });

  /// Helper function to get the full name
  String get fullName => '$firstName $lastName';

  /// Helper function to format phone number
  String get formatPhoneNo => EFormatter.formatNumber(phoneNumber);

  /// Static function to split full name into first and last name
  static List<String> nameParts(fullName) => fullName.split(" ");

  /// Static function to generate a userName from the full name
  static String generateUsername(fullName) {
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseUserName =
        "$firstName$lastName"; // Combine first and last name

    String userNameWithPrefix = "cwt_$camelCaseUserName"; // Add "cwt_" prefix
    return userNameWithPrefix;
  }

  /// Static function to crate a empty user model.
  static UserModel empty() => UserModel(
        id: '',
        firstName: '',
        lastName: '',
        userName: '',
        email: '',
        phoneNumber: '',
        profilePicture: '',
        bloodType: '',
        isAvailable: '',
        deviceToken: '',
        bloodDisability: '',
        city: '',
        lastDonationDate: '',
        userType: 'donar',
      );

  /// Convert model to Json structure to store data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'UserName': userName,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
      'bloodType': bloodType,
      'isAvailable': isAvailable,
      'deviceToken': deviceToken,
      'bloodDisability': bloodDisability,
      'city': city,
      'lastDonationDate': lastDonationDate,
      'userType': userType,
    };
  }

  /// Factory method to crate UserModel from a Firebase document snapshot.
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      // log(data.toString());
      return UserModel(
        id: document.id,
        firstName: data['FirstName'] ?? '',
        lastName: data['LastName'] ?? '',
        userName: data['UserName'] ?? '',
        email: data['Email'] ?? '',
        phoneNumber: data['PhoneNumber'] ?? '',
        profilePicture: data['ProfilePicture'] ?? '',
        bloodType: data['bloodType'] ?? '',
        isAvailable: data['isAvailable'] ?? '',
        deviceToken: data['deviceToken'] ?? '',
        bloodDisability: data['bloodDisability'] ?? '',
        city: data['city'] ?? '',
        lastDonationDate: data['lastDonationDate'] ?? '',
        userType: data['userType'] ?? '',
      );
    } else {
      return UserModel.empty();
    }
  }
}
