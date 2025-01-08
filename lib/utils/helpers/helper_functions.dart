import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class EHelperFunctions {
  static Color? getColor(String value) {
    /// Define your product specific colors here and it will match the attribute color and show specific

    if (value == 'Green') {
      return Colors.green;
    } else if (value == 'Red') {
      return Colors.red;
    } else if (value == 'Blue') {
      return Colors.blue;
    } else if (value == 'Pink') {
      return Colors.pink;
    } else if (value == 'Grey') {
      return Colors.grey;
    } else if (value == 'Black') {
      return Colors.black;
    } else if (value == 'White') {
      return Colors.white;
    } else if (value == 'Brown') {
      return Colors.brown;
    } else if (value == 'Teal') {
      return Colors.teal;
    } else if (value == 'Indigo') {
      return Colors.indigo;
    } else if (value == 'Yellow') {
      return Colors.yellow;
    } else if (value == 'Orange') {
      return Colors.deepOrange;
    }
    return null;
  }

  // show snackBar
  static void showSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 1300),
      ),
    );
  }

  // toast message
  // static showToastMessage(String message) {
  //   Fluttertoast.showToast(
  //     msg: message,
  //     gravity: ToastGravity.BOTTOM,
  //   );
  // }

  // flushBar
  static showFlushBar(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        message: message,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        borderRadius: BorderRadius.circular(12),
        backgroundColor: Colors.teal,
      )..show(context),
    );
  }

  // show alert
  static void showAlert(String title, String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // navigate to other screen
  static void navigateToOtherScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  // truncate text
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  // isDark mode
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  // screen size
  static Size screenSize() {
    return MediaQuery.of(Get.context!).size;
  }

  // screen height
  static double screenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  // screen width
  static double screenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }

  // wrapped list
  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    final wrapperList = <Widget>[];

    for (var i = 0; i < widgets.length; i += rowSize) {
      final rowChildren = widgets.sublist(
          i, i + rowSize > widgets.length ? widgets.length : i + rowSize);
      wrapperList.add(Row(children: rowChildren));
    }
    return wrapperList;
  }
}
