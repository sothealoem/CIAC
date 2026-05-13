import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';

class HomeworkController extends GetxController {
  final RxBool isAssignmentsLoading = false.obs;
  bool shouldShowAssignmentsLoading = false;

  final RxList<HomeworkAssignment> assignedHomeworkItems =
      <HomeworkAssignment>[
        const HomeworkAssignment(
          id: 'math-worksheet-chapter-4',
          title: 'Math worksheet chapter 4',
          className: 'Grade 5B',
          deadline: '12 May 2026',
          submitted: 24,
          total: 36,
          description: 'Complete all questions on multiplication practice.',
        ),
        const HomeworkAssignment(
          id: 'khmer-reading-summary',
          title: 'Khmer reading summary',
          className: 'Grade 4A',
          deadline: '14 May 2026',
          submitted: 31,
          total: 35,
          description: 'Write a short summary from today reading lesson.',
        ),
        const HomeworkAssignment(
          id: 'science-plant-observation',
          title: 'Science plant observation',
          className: 'Grade 3A',
          deadline: '16 May 2026',
          submitted: 18,
          total: 32,
          description: 'Upload one photo and write three observation notes.',
        ),
      ].obs;
  final RxSet<String> submittedAssignmentIds = <String>{}.obs;

  bool get isParentRole => UserRepository.shared.isDriver;
  int get totalAssignments => assignedHomeworkItems.length;
  int get submittedAssignments => submittedAssignmentIds.length;
  int get pendingAssignments => totalAssignments - submittedAssignments;
  double get homeworkProgress =>
      totalAssignments == 0 ? 0 : submittedAssignments / totalAssignments;

  HomeworkAssignment buildAssignment({
    String? id,
    required String title,
    required String className,
    required String deadline,
    required String description,
    int submitted = 0,
    int total = 0,
  }) {
    return HomeworkAssignment(
      id: id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      className: className,
      deadline: deadline.trim().isEmpty ? 'No deadline' : deadline.trim(),
      submitted: submitted,
      total: total,
      description: description,
    );
  }

  Future<void> showAssignmentsLoading() async {
    shouldShowAssignmentsLoading = false;
    isAssignmentsLoading.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    isAssignmentsLoading.value = false;
  }

  void requestAssignmentsLoading() {
    shouldShowAssignmentsLoading = true;
  }

  void addAssignment(HomeworkAssignment item) {
    assignedHomeworkItems.insert(0, item);
  }

  void updateAssignment(HomeworkAssignment item) {
    final index = assignedHomeworkItems.indexWhere(
      (current) => current.id == item.id,
    );
    if (index == -1) return;
    assignedHomeworkItems[index] = item;
  }

  bool isStudentSubmitted(String assignmentId) {
    return submittedAssignmentIds.contains(assignmentId);
  }

  void submitStudentHomework(String assignmentId) {
    submittedAssignmentIds.add(assignmentId);
  }

  String formatDeadline(DateTime picked) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${picked.day} ${months[picked.month - 1]} ${picked.year}';
  }
}

class HomeworkAssignment {
  const HomeworkAssignment({
    required this.id,
    required this.title,
    required this.className,
    required this.deadline,
    required this.submitted,
    required this.total,
    required this.description,
  });

  final String id;
  final String title;
  final String className;
  final String deadline;
  final int submitted;
  final int total;
  final String description;
}
