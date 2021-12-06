import 'dart:convert';

import 'package:sembast/timestamp.dart';

/// main logbook class
class LogBook {
  int? id; // auto incremented, used by sembast db
  String? workdone;
  String? jsonContent;
  String? filePath;
  final Timestamp? date;

  LogBook({this.id, this.workdone, this.date, this.jsonContent, this.filePath});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'workdone': workdone,
      'date': date,
      'jsonContent': jsonContent,
      'filePath': filePath,
    };
  }

  factory LogBook.fromMap(Map<String, dynamic> map) {
    return LogBook(
      id: map['id'] ?? 0,
      workdone: map['workdone'] ?? '',
      date: map['date'],
      jsonContent: map['jsonContent'],
      filePath: map['filePath'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'LogBook(id: $id, workdone: $workdone, date: $date, jsonContent: $jsonContent, filePath: $filePath)';
}
