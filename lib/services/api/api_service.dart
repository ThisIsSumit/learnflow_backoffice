// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:learnflow_backoffice/dto/bookings_response.dto.dart';
import 'package:learnflow_backoffice/dto/chats_response.dto.dart';
import 'package:learnflow_backoffice/dto/documents_response.dto.dart';
import 'package:learnflow_backoffice/dto/evaluations_response.dto.dart';
import 'package:learnflow_backoffice/dto/justificatives_response.dto.dart';
import 'package:learnflow_backoffice/dto/jwt_response.dto.dart';
import 'package:learnflow_backoffice/dto/login_information.dto.dart';
import 'package:learnflow_backoffice/dto/managers_response.dto.dart';
import 'package:learnflow_backoffice/dto/moderators_response.dto.dart';
import 'package:learnflow_backoffice/dto/payments_response.dto.dart';
import 'package:learnflow_backoffice/dto/ratings_response.dto.dart';
import 'package:learnflow_backoffice/dto/report_types_response.dto.dart';
import 'package:learnflow_backoffice/dto/reports_response.dto.dart';
import 'package:learnflow_backoffice/dto/school_subject_taughts_response.dto.dart';
import 'package:learnflow_backoffice/dto/school_subjects_response.dto.dart';
import 'package:learnflow_backoffice/dto/students_response.dto.dart';
import 'package:learnflow_backoffice/dto/teacher_validations_response.dto.dart';
import 'package:learnflow_backoffice/dto/teachers_response.dto.dart';
import 'package:learnflow_backoffice/models/booking.dart';
import 'package:learnflow_backoffice/models/chat.dart';
import 'package:learnflow_backoffice/models/document.dart';
import 'package:learnflow_backoffice/models/evaluation.dart';
import 'package:learnflow_backoffice/models/justificative.dart';
import 'package:learnflow_backoffice/models/manager.dart';
import 'package:learnflow_backoffice/models/moderator.dart';
import 'package:learnflow_backoffice/models/payment.dart';
import 'package:learnflow_backoffice/models/rating.dart';
import 'package:learnflow_backoffice/models/report.dart';
import 'package:learnflow_backoffice/models/report_type.dart';
import 'package:learnflow_backoffice/models/school_subject.dart';
import 'package:learnflow_backoffice/models/school_subject_taught.dart';
import 'package:learnflow_backoffice/models/student.dart';
import 'package:learnflow_backoffice/models/teacher.dart';
import 'package:learnflow_backoffice/models/teacher_validation.dart';
import 'package:learnflow_backoffice/services/env/env.dart';

final apiServiceProvider =
    Provider.family<ApiService, String?>((ref, apiToken) {
  final baseOptions = BaseOptions(
    baseUrl: _normalizeApiBaseUrl(Env.apiBaseUrl),
    headers: apiToken != null ? {'Authorization': 'Bearer $apiToken'} : null,
    contentType: 'application/json',
  );
  final dio = Dio(baseOptions);
  return ApiService(dio);
});

String _normalizeApiBaseUrl(String baseUrl) {
  final trimmed = baseUrl.trim();
  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    return trimmed;
  }
  return 'http://$trimmed';
}

class ApiService {
  ApiService(this._dio);

  final Dio _dio;

  dynamic _unwrapData(dynamic payload) {
    if (payload is Map<String, dynamic> && payload.containsKey('data')) {
      return payload['data'];
    }
    return payload;
  }

  Map<String, dynamic> _asMap(dynamic payload) {
    final unwrapped = _unwrapData(payload);
    return unwrapped is Map<String, dynamic> ? unwrapped : <String, dynamic>{};
  }

  Map<String, dynamic> _asEnvelopeMap(dynamic payload) {
    return payload is Map<String, dynamic> ? payload : <String, dynamic>{};
  }

  List<Map<String, dynamic>> _asListOfMaps(dynamic payload) {
    final unwrapped = _unwrapData(payload);
    if (unwrapped is List) {
      return unwrapped.whereType<Map<String, dynamic>>().toList();
    }
    return <Map<String, dynamic>>[];
  }

  bool _asBool(dynamic payload) {
    final unwrapped = _unwrapData(payload);
    if (unwrapped is bool) {
      return unwrapped;
    }
    if (payload is Map<String, dynamic> && payload['success'] is bool) {
      return payload['success'] as bool;
    }
    return false;
  }

  Future<dynamic> healthCheck() async {
    final response = await _dio.get('/health');
    return response.data;
  }

  Future<JwtResponse> login(LoginInformation loginInformation) async {
    final response = await _dio.post(
      '/auth/login',
      data: loginInformation.toJson(),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    return JwtResponse.fromJson(_asMap(response.data));
  }

  Future<void> logout() async {
    await _dio.post('/auth/logout');
  }

  Future<BookingsResponse> getBookings(
      {int? page, int? limit, String? search}) async {
    final response = await _dio.get(
      '/bookings',
      queryParameters: {
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    return BookingsResponse.fromJson(_asEnvelopeMap(response.data));
  }

  Future<Booking> getBooking(String _id) async {
    final response = await _dio.get('/bookings/$_id');
    return Booking.fromJson(_asMap(response.data));
  }

  Future<Booking> createBooking(Booking booking) async {
    final response = await _dio.post('/bookings/', data: booking.toJson());
    return Booking.fromJson(_asMap(response.data));
  }

  Future<List<Booking>> updateBooking(String _id, Booking booking) async {
    final response =
        await _dio.patch('/bookings/$_id/', data: booking.toJson());
    return _asListOfMaps(response.data).map(Booking.fromJson).toList();
  }

  Future<bool> deleteBooking(String _id) async {
    final response = await _dio.delete('/bookings/$_id');
    return _asBool(response.data);
  }

  Future<ChatsResponse> getChats(
      {int? page, int? limit, String? search}) async {
    final response = await _dio.get(
      '/chats',
      queryParameters: {
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    return ChatsResponse.fromJson(_asEnvelopeMap(response.data));
  }

  Future<Chat> getChat(String _id) async {
    final response = await _dio.get('/chats/$_id');
    return Chat.fromJson(_asMap(response.data));
  }

  Future<Chat> createChat(Chat chat) async {
    final response = await _dio.post('/chats/', data: chat.toJson());
    return Chat.fromJson(_asMap(response.data));
  }

  Future<DocumentsResponse> getDocuments(
      {int? page, int? limit, String? search}) async {
    final response = await _dio.get(
      '/documents',
      queryParameters: {
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    return DocumentsResponse.fromJson(_asEnvelopeMap(response.data));
  }

  Future<Document> getDocument(String _id) async {
    final response = await _dio.get('/documents/$_id');
    return Document.fromJson(_asMap(response.data));
  }

  Future<Document> createDocument(Document document) async {
    final response = await _dio.post('/documents/', data: document.toJson());
    return Document.fromJson(_asMap(response.data));
  }

  Future<List<Document>> updateDocument(String _id, Document document) async {
    final response =
        await _dio.patch('/documents/$_id/', data: document.toJson());
    return _asListOfMaps(response.data).map(Document.fromJson).toList();
  }

  Future<bool> deleteDocument(String _id) async {
    final response = await _dio.delete('/documents/$_id');
    return _asBool(response.data);
  }

  Future<List<Chat>> updateChat(String _id, Chat chat) async {
    final response = await _dio.patch('/chats/$_id/', data: chat.toJson());
    return _asListOfMaps(response.data).map(Chat.fromJson).toList();
  }

  Future<EvaluationsResponse> getEvaluations(
      {int? page, int? limit, String? search}) async {
    final response = await _dio.get(
      '/evaluations',
      queryParameters: {
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    return EvaluationsResponse.fromJson(_asEnvelopeMap(response.data));
  }

  Future<Evaluation> getEvaluation(String _id) async {
    final response = await _dio.get('/evaluations/$_id');
    return Evaluation.fromJson(_asMap(response.data));
  }

  Future<Evaluation> createEvaluation(Evaluation evaluation) async {
    final response =
        await _dio.post('/evaluations/', data: evaluation.toJson());
    return Evaluation.fromJson(_asMap(response.data));
  }

  Future<List<Evaluation>> updateEvaluation(
      String _id, Evaluation evaluation) async {
    final response =
        await _dio.patch('/evaluations/$_id/', data: evaluation.toJson());
    return _asListOfMaps(response.data).map(Evaluation.fromJson).toList();
  }

  Future<bool> deleteEvaluation(String _id) async {
    final response = await _dio.delete('/evaluations/$_id');
    return _asBool(response.data);
  }

  Future<JustificativesResponse> getJustificatives(
      {int? page, int? limit, String? search}) async {
    final response = await _dio.get(
      '/justificatives',
      queryParameters: {
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    return JustificativesResponse.fromJson(_asEnvelopeMap(response.data));
  }

  Future<Justificative> getJustificative(String _id) async {
    final response = await _dio.get('/justificatives/$_id');
    return Justificative.fromJson(_asMap(response.data));
  }

  Future<Justificative> createJustificative(Justificative justificative) async {
    final response =
        await _dio.post('/justificatives/', data: justificative.toJson());
    return Justificative.fromJson(_asMap(response.data));
  }

  Future<List<Justificative>> updateJustificative(
    String _id,
    Justificative justificative,
  ) async {
    final response =
        await _dio.patch('/justificatives/$_id/', data: justificative.toJson());
    return _asListOfMaps(response.data).map(Justificative.fromJson).toList();
  }

  Future<bool> deleteJustificative(String _id) async {
    final response = await _dio.delete('/justificatives/$_id');
    return _asBool(response.data);
  }

  Future<ManagersResponse> getManagers(
      {int? page, int? limit, String? search}) async {
    final response = await _dio.get(
      '/managers',
      queryParameters: {
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    return ManagersResponse.fromJson(_asEnvelopeMap(response.data));
  }

  Future<Manager> getManager(String _id) async {
    final response = await _dio.get('/managers/$_id');
    return Manager.fromJson(_asMap(response.data));
  }

  Future<Manager> createManager(Manager manager) async {
    final response = await _dio.post('/managers/', data: manager.toJson());
    return Manager.fromJson(_asMap(response.data));
  }

  Future<List<Manager>> updateManager(String _id, Manager manager) async {
    final response =
        await _dio.patch('/managers/$_id/', data: manager.toJson());
    return _asListOfMaps(response.data).map(Manager.fromJson).toList();
  }

  Future<bool> deleteManager(String _id) async {
    final response = await _dio.delete('/managers/$_id');
    return _asBool(response.data);
  }

  Future<ModeratorsResponse> getModerators(
      {int? page, int? limit, String? search}) async {
    final response = await _dio.get(
      '/moderators',
      queryParameters: {
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    return ModeratorsResponse.fromJson(_asEnvelopeMap(response.data));
  }

  Future<Moderator> getModerator(String _id) async {
    final response = await _dio.get('/moderators/$_id');
    return Moderator.fromJson(_asMap(response.data));
  }

  Future<Moderator> createModerator(Moderator moderator) async {
    final response = await _dio.post('/moderators/', data: moderator.toJson());
    return Moderator.fromJson(_asMap(response.data));
  }

  Future<List<Moderator>> updateModerator(
      String _id, Moderator moderator) async {
    final response =
        await _dio.patch('/moderators/$_id/', data: moderator.toJson());
    return _asListOfMaps(response.data).map(Moderator.fromJson).toList();
  }

  Future<bool> deleteModerator(String _id) async {
    final response = await _dio.delete('/moderators/$_id');
    return _asBool(response.data);
  }

  Future<PaymentsResponse> getPayments(
      {int? page, int? limit, String? search}) async {
    final response = await _dio.get(
      '/payments',
      queryParameters: {
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    return PaymentsResponse.fromJson(_asEnvelopeMap(response.data));
  }

  Future<Payment> getPayment(String _id) async {
    final response = await _dio.get('/payments/$_id');
    return Payment.fromJson(_asMap(response.data));
  }

  Future<Payment> createPayment(Payment payment) async {
    final response = await _dio.post('/payments/', data: payment.toJson());
    return Payment.fromJson(_asMap(response.data));
  }

  Future<List<Payment>> updatePayment(String _id, Payment payment) async {
    final response =
        await _dio.patch('/payments/$_id/', data: payment.toJson());
    return _asListOfMaps(response.data).map(Payment.fromJson).toList();
  }

  Future<bool> deletePayment(String _id) async {
    final response = await _dio.delete('/payments/$_id');
    return _asBool(response.data);
  }

  Future<RatingsResponse> getRatings(
      {int? page, int? limit, String? search}) async {
    final response = await _dio.get(
      '/ratings',
      queryParameters: {
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    return RatingsResponse.fromJson(_asEnvelopeMap(response.data));
  }

  Future<Rating> getRating(String _id) async {
    final response = await _dio.get('/ratings/$_id');
    return Rating.fromJson(_asMap(response.data));
  }

  Future<Rating> createRating(Rating rating) async {
    final response = await _dio.post('/ratings/', data: rating.toJson());
    return Rating.fromJson(_asMap(response.data));
  }

  Future<List<Rating>> updateRating(String _id, Rating rating) async {
    final response = await _dio.patch('/ratings/$_id/', data: rating.toJson());
    return _asListOfMaps(response.data).map(Rating.fromJson).toList();
  }

  Future<bool> deleteRating(String _id) async {
    final response = await _dio.delete('/ratings/$_id');
    return _asBool(response.data);
  }

  Future<ReportTypesResponse> getReportTypes(
      {int? page, int? limit, String? search}) async {
    final response = await _dio.get(
      '/report-types',
      queryParameters: {
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    return ReportTypesResponse.fromJson(_asEnvelopeMap(response.data));
  }

  Future<ReportType> getReportType(String _id) async {
    final response = await _dio.get('/report-types/$_id');
    return ReportType.fromJson(_asMap(response.data));
  }

  Future<ReportType> createReportType(ReportType reportType) async {
    final response =
        await _dio.post('/report-types/', data: reportType.toJson());
    return ReportType.fromJson(_asMap(response.data));
  }

  Future<List<ReportType>> updateReportType(
      String _id, ReportType reportType) async {
    final response =
        await _dio.patch('/report-types/$_id/', data: reportType.toJson());
    return _asListOfMaps(response.data).map(ReportType.fromJson).toList();
  }

  Future<bool> deleteReportType(String _id) async {
    final response = await _dio.delete('/report-types/$_id');
    return _asBool(response.data);
  }

  Future<ReportsResponse> getReports(
      {int? page, int? limit, String? search}) async {
    final response = await _dio.get(
      '/reports',
      queryParameters: {
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    return ReportsResponse.fromJson(_asEnvelopeMap(response.data));
  }

  Future<Report> getReport(String _id) async {
    final response = await _dio.get('/reports/$_id');
    return Report.fromJson(_asMap(response.data));
  }

  Future<Report> createReport(Report report) async {
    final response = await _dio.post('/reports/', data: report.toJson());
    return Report.fromJson(_asMap(response.data));
  }

  Future<List<Report>> updateReport(String _id, Report report) async {
    final response = await _dio.patch('/reports/$_id/', data: report.toJson());
    return _asListOfMaps(response.data).map(Report.fromJson).toList();
  }

  Future<bool> deleteReport(String _id) async {
    final response = await _dio.delete('/reports/$_id');
    return _asBool(response.data);
  }

  Future<SchoolSubjectTaughtsResponse> getSchoolSubjectTaughts(
      {int? page, int? limit, String? search}) async {
    final response = await _dio.get(
      '/school-subjects-taught',
      queryParameters: {
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    return SchoolSubjectTaughtsResponse.fromJson(_asEnvelopeMap(response.data));
  }

  Future<SchoolSubjectTaught> getSchoolSubjectTaught(String _id) async {
    final response = await _dio.get('/school-subjects-taught/$_id');
    return SchoolSubjectTaught.fromJson(_asMap(response.data));
  }

  Future<SchoolSubjectTaught> createSchoolSubjectTaught(
    SchoolSubjectTaught schoolSubjectsTeached,
  ) async {
    final response = await _dio.post(
      '/school-subjects-taught/',
      data: schoolSubjectsTeached.toJson(),
    );
    return SchoolSubjectTaught.fromJson(_asMap(response.data));
  }

  Future<List<SchoolSubjectTaught>> updateSchoolSubjectTaught(
    String _id,
    SchoolSubjectTaught report,
  ) async {
    final response = await _dio.patch('/school-subjects-taught/$_id/',
        data: report.toJson());
    return _asListOfMaps(response.data)
        .map(SchoolSubjectTaught.fromJson)
        .toList();
  }

  Future<bool> deleteSchoolSubjectTaught(String _id) async {
    final response = await _dio.delete('/school-subjects-taught/$_id');
    return _asBool(response.data);
  }

  Future<SchoolSubjectsResponse> getSchoolSubjects(
      {int? page, int? limit, String? search}) async {
    final response = await _dio.get(
      '/school-subjects',
      queryParameters: {
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    return SchoolSubjectsResponse.fromJson(_asEnvelopeMap(response.data));
  }

  Future<SchoolSubject> getSchoolSubject(String _id) async {
    final response = await _dio.get('/school-subjects/$_id');
    return SchoolSubject.fromJson(_asMap(response.data));
  }

  Future<SchoolSubject> createSchoolSubject(SchoolSubject schoolSubject) async {
    final response =
        await _dio.post('/school-subjects/', data: schoolSubject.toJson());
    return SchoolSubject.fromJson(_asMap(response.data));
  }

  Future<List<SchoolSubject>> updateSchoolSubject(
    String _id,
    SchoolSubject schoolSubject,
  ) async {
    final response = await _dio.patch('/school-subjects/$_id/',
        data: schoolSubject.toJson());
    return _asListOfMaps(response.data).map(SchoolSubject.fromJson).toList();
  }

  Future<bool> deleteSchoolSubject(String _id) async {
    final response = await _dio.delete('/school-subjects/$_id');
    return _asBool(response.data);
  }

  Future<StudentsResponse> getStudents(
      {int? page, int? limit, String? search}) async {
    final response = await _dio.get(
      '/students',
      queryParameters: {
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    return StudentsResponse.fromJson(_asEnvelopeMap(response.data));
  }

  Future<Student> getStudent(String _id) async {
    final response = await _dio.get('/students/$_id');
    return Student.fromJson(_asMap(response.data));
  }

  Future<Student> createStudent(Student student) async {
    final response = await _dio.post('/students/', data: student.toJson());
    return Student.fromJson(_asMap(response.data));
  }

  Future<List<Student>> updateStudent(String _id, Student student) async {
    final response =
        await _dio.patch('/students/$_id/', data: student.toJson());
    return _asListOfMaps(response.data).map(Student.fromJson).toList();
  }

  Future<bool> deleteStudent(String _id) async {
    final response = await _dio.delete('/students/$_id');
    return _asBool(response.data);
  }

  Future<TeacherValidationsResponse> getTeacherValidations(
      {int? page, int? limit, String? search}) async {
    final response = await _dio.get(
      '/teacher-validations',
      queryParameters: {
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    return TeacherValidationsResponse.fromJson(_asEnvelopeMap(response.data));
  }

  Future<TeacherValidation> getTeacherValidation(String _id) async {
    final response = await _dio.get('/teacher-validations/$_id');
    return TeacherValidation.fromJson(_asMap(response.data));
  }

  Future<TeacherValidation> createTeacherValidation(
    TeacherValidation teacher,
  ) async {
    final response =
        await _dio.post('/teacher-validations/', data: teacher.toJson());
    return TeacherValidation.fromJson(_asMap(response.data));
  }

  Future<List<TeacherValidation>> updateTeacherValidation(
    String _id,
    TeacherValidation teacher,
  ) async {
    final response =
        await _dio.patch('/teacher-validations/$_id/', data: teacher.toJson());
    return _asListOfMaps(response.data)
        .map(TeacherValidation.fromJson)
        .toList();
  }

  Future<bool> deleteTeacherValidation(String _id) async {
    final response = await _dio.delete('/teacher-validations/$_id');
    return _asBool(response.data);
  }

  Future<TeachersResponse> getTeachers(
      {int? page, int? limit, String? search}) async {
    final response = await _dio.get(
      '/teachers',
      queryParameters: {
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    return TeachersResponse.fromJson(_asEnvelopeMap(response.data));
  }

  Future<Teacher> getTeacher(String _id) async {
    final response = await _dio.get('/teachers/$_id');
    return Teacher.fromJson(_asMap(response.data));
  }

  Future<Teacher> createTeacher(Teacher teacher) async {
    final response = await _dio.post('/teachers/', data: teacher.toJson());
    return Teacher.fromJson(_asMap(response.data));
  }

  Future<List<Teacher>> updateTeacher(String _id, Teacher teacher) async {
    final response =
        await _dio.patch('/teachers/$_id/', data: teacher.toJson());
    return _asListOfMaps(response.data).map(Teacher.fromJson).toList();
  }

  Future<Teacher> deleteTeacher(String _id) async {
    final response = await _dio.delete('/teachers/$_id');
    return Teacher.fromJson(_asMap(response.data));
  }
}
