import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'common Color.dart';

InputDecoration inputBox(String? label) {
  return InputDecoration(
    // hintMaxLines: 1,
    contentPadding: const EdgeInsets.only(bottom: 10.0),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: secondaryColor),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: secondaryColor),
    ),
    fillColor: Colors.grey.shade50,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide.none,
    ),
    hoverColor: lightShade,
    focusColor: secondaryColor,
    floatingLabelBehavior: FloatingLabelBehavior.never,
    filled: true,
    labelStyle: const TextStyle(
        color: grey100, fontSize: 15, fontWeight: FontWeight.w400),
    labelText: label,
  );
}

InputDecoration loginInput(Color? color, String? label) {
  return InputDecoration(
    fillColor: color,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    hoverColor: lightShade,
    contentPadding: const EdgeInsets.all(10.0),
    focusColor: secondaryColor,
    floatingLabelBehavior: FloatingLabelBehavior.never,
    filled: true,
    labelStyle: const TextStyle(
        color: grey100, fontWeight: FontWeight.w400, fontSize: 12),
    labelText: label,
  );
}

InputDecoration inputDateBox(String? label) {
  return InputDecoration(
    suffixIconColor: secondaryColor,
    suffixIcon: SizedBox(
      width: 25,
      child: Row(
        children: const [
          Icon(Icons.calendar_month, color: secondaryColor, size: 18),
          Icon(Icons.schedule_rounded, color: secondaryColor, size: 18),
        ],
      ),
    ),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: secondaryColor),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: secondaryColor),
    ),
    fillColor: Colors.grey.shade100,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide.none,
    ),
    hoverColor: lightShade,
    focusColor: secondaryColor,
    floatingLabelBehavior: FloatingLabelBehavior.never,
    filled: true,
    labelStyle: const TextStyle(
        color: grey100, fontSize: 15, fontWeight: FontWeight.w400),
    labelText: label,
  );
}

BoxDecoration disableDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(10),
  color: grey50,
);

BoxDecoration dropDown = BoxDecoration(
  borderRadius: BorderRadius.circular(8.0),
  color: Colors.grey.shade50,
);

BoxDecoration dropDownDecoration = BoxDecoration(
  color: Colors.grey.shade50,
  border: const Border(
    bottom: BorderSide(color: secondaryColor, width: 1),
  ),
);

RoundedRectangleBorder disableField =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0));

const TextStyle headerStyle = TextStyle(
    color: Colors.black,
    fontSize: 24,
    overflow: TextOverflow.clip,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto');

TextStyle styledHeader = GoogleFonts.raleway(
    textStyle: const TextStyle(
        color: Colors.black,
        fontSize: 24,
        overflow: TextOverflow.clip,
        fontWeight: FontWeight.w500,
        fontFamily: 'Roboto'));

const TextStyle inputHeader =
    TextStyle(fontSize: 15, color: secondaryColor, fontWeight: FontWeight.w400);

const TextStyle textBtn = TextStyle(
    color: red, letterSpacing: 0.3, fontSize: 13, fontWeight: FontWeight.w500);

const TextStyle secondaryHeader = TextStyle(
    color: grey100,
    overflow: TextOverflow.clip,
    fontSize: 18,
    fontWeight: FontWeight.w300);

const TextStyle menuStyle =
    TextStyle(color: secondaryColor, fontSize: 11, fontWeight: FontWeight.w400);

TextStyle commonRoboto = GoogleFonts.roboto(
    textStyle: const TextStyle(
        overflow: TextOverflow.clip,
        color: Colors.black,
        fontSize: 22,
        fontWeight: FontWeight.w400));

TextStyle pageHeaderWeb = GoogleFonts.roboto(
    textStyle: const TextStyle(
        overflow: TextOverflow.clip,
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w500));

TextStyle txtBtn1 = GoogleFonts.roboto(
    textStyle: const TextStyle(
        overflow: TextOverflow.clip,
        color: grey100,
        fontSize: 13,
        fontWeight: FontWeight.w400));

TextStyle tileHeader = GoogleFonts.roboto(
    textStyle: const TextStyle(
        overflow: TextOverflow.clip,
        color: secondaryColor,
        fontSize: 13,
        fontWeight: FontWeight.w500));

TextStyle textInputHeader = GoogleFonts.roboto(
    textStyle: const TextStyle(
        overflow: TextOverflow.clip,
        color: secondaryColor,
        fontSize: 16,
        fontWeight: FontWeight.w400));

TextStyle cardValue = GoogleFonts.roboto(
    textStyle: TextStyle(
        overflow: TextOverflow.clip,
        color: Colors.grey.shade700,
        fontSize: 11,
        fontWeight: FontWeight.w400));

final TextStyle commonStyle = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade700);

final TextStyle countStyle = GoogleFonts.robotoSlab(
    textStyle: const TextStyle(
        fontSize: 70, color: Colors.white, fontWeight: FontWeight.w300));

final TextStyle webCountStyle = GoogleFonts.robotoSlab(
    textStyle: const TextStyle(
        fontSize: 20, color: Colors.white, fontWeight: FontWeight.w300));

const TextStyle webCountName = TextStyle(
    overflow: TextOverflow.clip,
    color: Colors.white,
    fontSize: 9,
    fontWeight: FontWeight.w300);

const TextStyle cardHeading =
    TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14);

TextStyle styledHeading = GoogleFonts.raleway(
    textStyle: const TextStyle(
        color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14));

const TextStyle cardTitle =
    TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 14);

const TextStyle cardSubTitle =
    TextStyle(color: Colors.grey, fontWeight: FontWeight.w300, fontSize: 14);

/// TABLE CARDVIEW ///
const TextStyle tableCardTextLeft = TextStyle(
  fontSize: 12,
  color: secondaryColor,
  overflow: TextOverflow.clip,
);
final TextStyle tableCardTextRight = TextStyle(
  fontSize: 10,
  color: Colors.grey.shade700,
  overflow: TextOverflow.clip,
);

///

/// Card View ///
const TextStyle cardHeader = TextStyle(
  fontSize: 12,
  color: secondaryColor,
  fontWeight: FontWeight.w600,
  overflow: TextOverflow.clip,
);
const TextStyle cardBody = TextStyle(
  fontSize: 10,
  color: secondaryColor,
  overflow: TextOverflow.clip,
);

/// TableStyle ///
const TextStyle columnStyle =
    TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600);
const TextStyle rowstyle = TextStyle(
  fontSize: 10,
  color: Colors.black,
  fontWeight: FontWeight.w500,
  overflow: TextOverflow.ellipsis,
);

///---///

///
const TextStyle dCardHead = TextStyle(
  fontSize: 36,
  color: secondaryColor,
  fontWeight: FontWeight.w400,
  overflow: TextOverflow.clip,
);
const TextStyle cardHeader2 = TextStyle(
  fontSize: 14,
  color: Colors.black,
  fontWeight: FontWeight.w400,
  overflow: TextOverflow.clip,
);
const TextStyle dCardContent = TextStyle(
  fontSize: 10,
  color: secondaryColor,
  fontWeight: FontWeight.w300,
  overflow: TextOverflow.clip,
);
TextStyle tileHeaderBlack = GoogleFonts.roboto(
    textStyle: const TextStyle(
        overflow: TextOverflow.clip,
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.w500));
const TextStyle appBar =
    TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600);

const TextStyle statusHead =
    TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500);

const TextStyle statusContent = TextStyle(
    color: Color(0xff03AC13), fontSize: 16, fontWeight: FontWeight.w500);
