import 'package:flutter/material.dart';

double getGifWidth(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth > 1200) {
    return 500; //desktop size
  } else if (screenWidth > 800) {
    return 350; //tablet size
  } else {
    return 250; //mobile phone size
  }
}
