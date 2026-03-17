import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/student.dart';

class ExportService {
  static Future<String> exportCSV(List<Student> students) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = "${dir.path}/report.csv";

    final file = File(path);

    String csv =
        "Name,Matricule,CA,Exam,Total,Grade,Rank\n";

    for (var s in students) {
      csv +=
          "${s.name},${s.matricule},${s.ca ?? ''},${s.exam ?? ''},${s.total ?? ''},${s.grade},${s.rank}\n";
    }

    await file.writeAsString(csv);

    return path;
  }
}