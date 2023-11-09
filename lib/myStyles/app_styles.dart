import 'package:flutter/material.dart';
import '../constants/colors.dart';

TextStyle Style_HeaderText() {
  return const TextStyle(fontSize: 20.0, color: WHITE);
}

TextStyle Style_SubHeaderText() {
  return const TextStyle(
      fontSize: 20.0,
      color: APP_COLORS.Primary,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.overline);
}

TextStyle Style_ListViewText() {
  return const TextStyle(
      fontSize: 18.0,
      color: APP_COLORS.Primary,
      fontFamily: AutofillHints.birthdayDay);
}

TextStyle Style_ALLText() {
  return const TextStyle(
      fontSize: 18.0,
      color: APP_COLORS.Primary,
      fontFamily: AutofillHints.familyName);
}

//
TextStyle Style_ALLText_md() {
  return const TextStyle(
      fontSize: 14.0,
      color: APP_COLORS.Primary,
      fontFamily: AutofillHints.familyName);
}
// TextStyle Style_LabelInputField(){
//   return const TextStyle(
//     fontSize: 20,
//     fontWeight: FontWeight.w400,
//     color: WHITE,
//   );
// }
//
// TextStyle Style_Hint(){
//   return TextStyle(
//     fontSize: 20,
//     fontWeight: FontWeight.w400,
//     color: Colors.white,
//   );
// }

BorderSide Style_InputField_BorderSide() {
  return const BorderSide(color: BLACK, width: 2.0, style: BorderStyle.solid);
}

OutlineInputBorder Style_InputField_Border() {
  return OutlineInputBorder(borderSide: Style_InputField_BorderSide());
}

InputDecoration InputEmail_Decoration() {
  return const InputDecoration(
    labelText: 'Email',
    suffixIcon: Icon(
      Icons.email,
      size: 20,
      color: BLACK,
    ),
    labelStyle: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: APP_COLORS.Primary,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(3)),
    ),
    hintText: 'user@gmail.com',
    hintStyle: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: APP_COLORS.Primary,
    ),
  );
}

InputDecoration InputPassword_Decoration() {
  return const InputDecoration(
    labelText: 'Password',
    suffixIcon: Icon(
      Icons.vpn_key_rounded,
      size: 20,
      color: BLACK,
    ),
    labelStyle: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: APP_COLORS.Primary,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(3)),
    ),
    hintText: '*',
    hintStyle: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: BLACK,
    ),
  );
}

InputDecoration InputConfirmPassword_Decoration() {
  return const InputDecoration(
    labelText: 'Confirm Password',
    suffixIcon: Icon(
      Icons.vpn_key_rounded,
      size: 20,
      color: BLACK,
    ),
    labelStyle: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: APP_COLORS.Primary,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(3)),
    ),
    hintText: '*',
    hintStyle: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: BLACK,
    ),
  );
}
