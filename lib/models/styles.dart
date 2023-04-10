import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Text Styles
const kFontSizeSuperSmall = 10.0;
const kFontSizeSmall = 13.0;
const kFontSizeNormal = 16.0;
const kFontSizeMedium = 18.0;
const kFontSizeLarge = 25.0;

const kPageTitleStyle = TextStyle(
  fontSize: kFontSizeLarge,
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.bold,
);

const kPageSubtitleStyle = TextStyle(
  color: kColorAccent,
  fontSize: 17.5,
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.bold,
);

const kSpeakerTitleStyle = TextStyle(
  fontSize: kFontSizeMedium,
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.normal,
);
const kSpeakerDescriptionStyle = TextStyle(
  color: Color(0xFF8E8E93),
  fontSize: kFontSizeSmall,
  fontWeight: FontWeight.w300,
);

///SETTINGS
const kSettingsDescriptionStyle = TextStyle(
  color: Color(0xFF8E8E93),
  fontSize: 15,
  fontWeight: FontWeight.normal,
);

// UI Colors
const kColorAccent = CupertinoColors.activeBlue;
const kColorError = Colors.red;
const kColorSuccess = Colors.green;
const kColorDivider = Color(0xFFD9D9D9);
const kColorGrey = Color(0xFF8E8E93);
const kColorWhite = CupertinoColors.white;
const kColorBlack = Color.fromRGBO(0, 0, 0, 0.8);
