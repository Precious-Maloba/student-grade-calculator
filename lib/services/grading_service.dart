import '../models/student.dart';

class GradingService {
  static String getGrade(double score) {
    if (score >= 90) return 'A';
    if (score >= 80) return 'B';
    if (score >= 70) return 'C';
    if (score >= 60) return 'D';
    return 'F';
  }

  static void process(List<Student> students) {
    for (var s in students) {
      if (s.ca != null && s.exam != null) {
        s.total = (s.ca! * 0.4) + (s.exam! * 0.6);
        s.grade = getGrade(s.total!);
      } else {
        s.total = null;
        s.grade = "No Score";
      }
    }

    // Sort descending
    students.sort((a, b) => (b.total ?? 0).compareTo(a.total ?? 0));

    // Rank with ties
    int rank = 1;
    for (int i = 0; i < students.length; i++) {
      if (i > 0 && students[i].total == students[i - 1].total) {
        students[i].rank = students[i - 1].rank;
      } else {
        students[i].rank = rank;
      }
      rank++;
    }
  }
}

