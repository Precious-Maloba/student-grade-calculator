import 'dart:io';
import 'package:excel/excel.dart';
import '../models/student.dart';

class FileService {
  static List<Student> readExcel(String path) {
    final file = File(path);

    if (!file.existsSync()) {
      throw Exception("File not found");
    }

    final bytes = file.readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);

    List<Student> students = [];

    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows.skip(1)) {
        students.add(
          Student(
            name: row[0]?.value.toString() ?? '',
            matricule: row[1]?.value.toString() ?? '',
            ca: double.tryParse(row[2]?.value.toString() ?? ''),
            exam: double.tryParse(row[3]?.value.toString() ?? ''),
          ),
        );
      }
    }

    return students;
  }
}