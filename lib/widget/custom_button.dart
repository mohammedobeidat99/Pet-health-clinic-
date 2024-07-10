
import 'package:flutter/material.dart';

Widget mianButton({ color =Colors.green,  textcolor,required String?  title,  onPress}) {
  return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12)
      ),
      width: double.infinity,
      child: TextButton(
        onPressed: onPress,
        child: Text(title! , style: TextStyle(color: textcolor ,fontWeight: FontWeight.bold ,fontSize: 16,fontFamily: 'dms_reguler'),),
      ));

  //.white.fontFamily(bold).make());
}
