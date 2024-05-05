import 'package:flutter/material.dart';

// const kMainColor = Color(0xFF3F8CFF);
const kMainColor = Color(0xFFE3C35A);
Color kBorderColorTextField = Colors.grey[400]!;





 InputDecoration kInputDecoration = InputDecoration(
  labelStyle: const TextStyle( fontSize: 14.0, fontWeight: FontWeight.w400,color: Colors.black54),
  suffixIconColor: Colors.black54,
  prefixIconColor: Colors.black54,
  hintStyle: TextStyle(color: kBorderColorTextField),
  filled: true,
  fillColor: Colors.white70,
  enabledBorder: OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(6.0)),
    borderSide: BorderSide(color: kBorderColorTextField, width: 1),
  ),
  focusedBorder: const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(6.0)),
    borderSide: BorderSide(color: kMainColor, width: 1),
  ),
  errorBorder: const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(6.0)),
    borderSide: BorderSide(color: kMainColor, width: 1),
  ),
  focusedErrorBorder: const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(6.0)),
    borderSide: BorderSide(color: kMainColor, width: 1),
  ),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide:  BorderSide(color: kBorderColorTextField),
  );
}

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);
