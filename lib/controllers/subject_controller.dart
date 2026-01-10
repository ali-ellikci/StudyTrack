import 'package:get/get.dart';
import '../services/subjects_service.dart';
import '../models/subject_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubjectController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SubjectsService _subjectsService = SubjectsService();
  var subjects = <SubjectModel>[].obs;
  var selectedSubject = Rxn<SubjectModel>();

  Future<void> fetchSubjects(String uId) async {
    final result = await _subjectsService.getSubjects(uId: uId);
    subjects.assignAll(result);
  }

  @override
  void onInit() {
    super.onInit();
    final current = _auth.currentUser;
    if (current != null) {
      fetchSubjects(current.uid);
    }
    _auth.authStateChanges().listen((u) {
      if (u != null) {
        fetchSubjects(u.uid);
      } else {
        subjects.clear();
        selectedSubject.value = null;
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
  }

  void changeSubject(SubjectModel? value) {
    selectedSubject.value = value;
  }

  void addSubject({required name}) {
    final u = _auth.currentUser;
    if (u == null) return;
    _subjectsService.createSubject(uId: u.uid, name: name);
    fetchSubjects(u.uid);
  }
}
