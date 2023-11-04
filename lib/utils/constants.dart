import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

// >>>>>>>>>> Text <<<<<<<<<<

final TextStyle kTitleTextStyle =
    GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.bold);

final TextStyle kBodyTextStyle = GoogleFonts.roboto(
  fontSize: 18,
  color: Colors.grey[500],
);
final TextStyle kBodyBlack =
    GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold);

final TextStyle kTaskTitle = GoogleFonts.roboto(fontSize: 18);

final TextStyle kHintTextStyle = GoogleFonts.roboto(
  color: Colors.grey,
  letterSpacing: .5,
);

final TextStyle kTextButtonSyle = GoogleFonts.roboto(fontSize: 18);

EdgeInsets responsivePadding(BuildContext context) {
  double horizontalPadding = MediaQuery.of(context).size.width * 0.05;
  return EdgeInsets.symmetric(horizontal: horizontalPadding);
}

double kPadding(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double paddingInPixels = 80.0;
  double paddingAsPercentage = (paddingInPixels / screenWidth) * 100;
  return paddingAsPercentage;
}

enum DateType { today, yesterday, other }
