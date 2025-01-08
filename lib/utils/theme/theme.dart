import '/utils/constants/colors.dart';
import '/utils/theme/custom_themes/appbar_theme.dart';
import '/utils/theme/custom_themes/bottom_sheet_theme.dart';
import '/utils/theme/custom_themes/checkbox_theme.dart';
import '/utils/theme/custom_themes/chip_theme.dart';
import '/utils/theme/custom_themes/elevated_button_theme.dart';
import '/utils/theme/custom_themes/outlined_button_theme.dart';
import '/utils/theme/custom_themes/text_field_theme.dart';
import '/utils/theme/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';

class EAppTheme {
  EAppTheme._(); // making the constructor private

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: EColors.light,
    primaryColor: Colors.blue,
    fontFamily: 'Poppins',
    useMaterial3: true,
    textTheme: ETextTheme.lightTextTheme,
    chipTheme: EChipTheme.lightChipTheme,
    appBarTheme: EAppBarTheme.lightAppBarTheme,
    checkboxTheme: ECheckBoxTheme.lightCheckBoxThemeData,
    bottomSheetTheme: EBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: EElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: EOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: ETextFieldTheme.lightInputDecorationTheme,
  );
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: EColors.dark,
    primaryColor: Colors.blue,
    fontFamily: 'Poppins',
    useMaterial3: true,
    textTheme: ETextTheme.darkTextTheme,
    chipTheme: EChipTheme.darkChipTheme,
    appBarTheme: EAppBarTheme.darkAppBarTheme,
    checkboxTheme: ECheckBoxTheme.darkCheckBoxThemeData,
    bottomSheetTheme: EBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: EElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: EOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: ETextFieldTheme.darkInputDecorationTheme,
  );
}
