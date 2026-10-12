import 'package:flutter/material.dart';


// Общий стиль рамок для полей модалки
OutlineInputBorder fieldBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(color: color),
  );
} 
