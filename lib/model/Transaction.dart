import 'package:flutter/material.dart';

class Transaction {
  String description;
  double amount;
  bool isRevenu;
  IconData icon;

  Transaction({required this.description, required this.amount, required this.isRevenu, required this.icon});
}