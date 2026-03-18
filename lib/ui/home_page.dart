import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../models/student.dart';
import '../services/file_service.dart';
import '../services/grading_service.dart';
import '../services/export_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Student> students = [];
  String message = "";

  Future<void> pickFile() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles();

      if (result == null) return;

      String path = result.files.single.path!;

      if (!path.endsWith(".xlsx")) {
        setState(() {
          message = "Please upload a valid Excel file (.xlsx)";
        });
        return;
      }

      var data = FileService.readExcel(path);
      GradingService.process(data);

      setState(() {
        students = data;
        message = "File processed successfully";
      });
    } catch (e) {
      setState(() {
        message = "Error: $e";
      });
    }
  }

  Future<void> exportFile() async {
    String path = await ExportService.exportCSV(students);

    setState(() {
      message = "Exported to: $path";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Grade Calculator")),
      body: Column(
        children: [
          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: pickFile,
            child: const Text("Upload Excel"),
          ),

          ElevatedButton(
            onPressed: students.isEmpty ? null : exportFile,
            child: const Text("Export CSV"),
          ),

          Text(message),

          const Divider(),

          Expanded(
            child: students.isEmpty
                ? const Center(child: Text("No data loaded"))
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Name")),
                        DataColumn(label: Text("Matricule")),
                        DataColumn(label: Text("Total")),
                        DataColumn(label: Text("Grade")),
                        DataColumn(label: Text("Rank")),
                      ],
                      rows: students.map((s) {
                        return DataRow(cells: [
                          DataCell(Text(s.name)),
                          DataCell(Text(s.matricule)),
                          DataCell(Text(s.total?.toStringAsFixed(2) ?? "-")),
                          DataCell(Text(s.grade ?? "-")),
                          DataCell(Text(s.rank?.toString() ?? "-")),
                        ]);
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}