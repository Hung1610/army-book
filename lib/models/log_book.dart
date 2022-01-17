import 'dart:convert';

import 'package:sembast/timestamp.dart';

/// main logbook class
class LogBook {
  int? id; // auto incremented, used by sembast db
  String? name;
  String? workdone;
  String? jsonContent;
  String? filePath;
  String? docType;
  final Timestamp? date;

  LogBook(
      {this.id,
      this.name,
      this.workdone,
      this.date,
      this.jsonContent,
      this.docType,
      this.filePath});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'workdone': workdone,
      'date': date,
      'jsonContent': jsonContent,
      'docType': docType,
      'filePath': filePath,
    };
  }

  factory LogBook.fromMap(Map<String, dynamic> map) {
    return LogBook(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      workdone: map['workdone'] ?? '',
      date: map['date'],
      jsonContent: map['jsonContent'],
      docType: map['docType'],
      filePath: map['filePath'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'LogBook(id: $id, workdone: $workdone, date: $date, jsonContent: $jsonContent, docType: $docType, filePath: $filePath)';
}
