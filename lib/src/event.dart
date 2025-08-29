// Event model for flutter_calanders
import 'package:flutter/material.dart';

class Event {
  final String eventName;
  final List<DateTime> dates;
  final Color color;

  Event({required this.eventName, required this.dates, required this.color});
}
