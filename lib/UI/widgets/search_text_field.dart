import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gallery/utils/strings.dart';

class SearchTextField extends StatelessWidget {
  final borderRadius = BorderRadius.circular(8.0);
  final borderSide = BorderSide(color: Colors.grey.shade50);
  final ValueChanged<String> onChanged;

  SearchTextField({Key key, @required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.0,
      child: TextField(
        onChanged: onChanged,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          hintText: AppStrings.searchHintText,
          fillColor: Color(0xfffFFFFFF),
          filled: true,
          labelStyle: TextStyle(color: Colors.grey.shade400),
          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: borderSide,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: borderSide,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: borderSide,
          ),
        ),
      ),
    );
  }
}
