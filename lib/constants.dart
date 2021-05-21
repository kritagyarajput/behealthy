import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BeHealthyTheme {
  static const kMainOrange = Color(0xffFF9629);
  static const kLightOrange = Color(0xffFFEDDB);
  static const kInsideCard = Color(0xffEAEAEA);
  static TextStyle kMainTextStyle = GoogleFonts.montserrat(
      color: BeHealthyTheme.kMainOrange,
      fontSize: 15,
      fontWeight: FontWeight.bold);
  static TextStyle kInputFieldTextStyle = GoogleFonts.montserrat(
    color: BeHealthyTheme.kMainOrange,
    fontSize: 15,
  );

  static TextStyle kProfileFont = GoogleFonts.lato(
    color: Color(0xff707070),
    fontSize: 12,
  );
  
  static TextStyle kDhaaTextStyle = GoogleFonts.lato(
      color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold);
  static TextStyle kDeliverToStyle = GoogleFonts.montserrat(
      fontSize: 12, fontWeight: FontWeight.w800, color: Colors.black);
  static TextStyle kAddressStyle = GoogleFonts.montserrat(
      fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black);
 
}
