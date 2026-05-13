import 'package:flutter/material.dart';

class Treatment {
  final String title;
  final IconData icon;
  final String image;
  final String description;
  final List<String> advantages;

  Treatment({
    required this.title,
    required this.icon,
    required this.image,
    required this.description,
    required this.advantages,
  });
}