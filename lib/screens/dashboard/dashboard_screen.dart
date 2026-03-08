import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:learnflow_backoffice/models/booking.dart';
import 'package:learnflow_backoffice/models/student.dart';
import 'package:learnflow_backoffice/models/teacher.dart';
import 'package:learnflow_backoffice/screens/home/widgets/app_bar.dart';
import 'package:learnflow_backoffice/services/api/api_service.dart';
import 'package:learnflow_backoffice/services/authentication/secure_storage.dart';

final dashboardDataProvider = FutureProvider<DashboardData>((ref) async {
  final apiToken = await ref.watch(secureStorageProvider).getApiToken();
  final apiService = ref.read(apiServiceProvider(apiToken));

  final studentsFuture = apiService.getStudents();
  final teachersFuture = apiService.getTeachers();
  final bookingsFuture = apiService.getBookings();
  final subjectsFuture = apiService.getSchoolSubjects();
  final evaluationsFuture = apiService.getEvaluations();
  final ratingsFuture = apiService.getRatings();
  final justificativesFuture = apiService.getJustificatives();
  final documentsFuture = apiService.getDocuments();
  final moderatorsFuture = apiService.getModerators();
  final reportsFuture = apiService.getReports();

  await Future.wait([
    studentsFuture,
    teachersFuture,
    bookingsFuture,
    subjectsFuture,
    evaluationsFuture,
    ratingsFuture,
    justificativesFuture,
    documentsFuture,
    moderatorsFuture,
    reportsFuture,
  ]);

  final studentsResponse = await studentsFuture;
  final teachersResponse = await teachersFuture;
  final bookingsResponse = await bookingsFuture;
  final subjectsResponse = await subjectsFuture;
  final evaluationsResponse = await evaluationsFuture;
  final ratingsResponse = await ratingsFuture;
  final justificativesResponse = await justificativesFuture;
  final documentsResponse = await documentsFuture;
  final moderatorsResponse = await moderatorsFuture;
  final reportsResponse = await reportsFuture;

  final students = studentsResponse.data ?? <Student>[];
  final teachers = teachersResponse.data ?? <Teacher>[];
  final bookings = bookingsResponse.data ?? <Booking>[];

  return DashboardData(
    studentsCount: students.length,
    teachersCount: teachers.length,
    bookingsCount: bookings.length,
    subjectsCount: subjectsResponse.data?.length ?? 0,
    evaluationsCount: evaluationsResponse.data?.length ?? 0,
    ratingsCount: ratingsResponse.data?.length ?? 0,
    justificativesCount: justificativesResponse.data?.length ?? 0,
    documentsCount: documentsResponse.data?.length ?? 0,
    moderatorsCount: moderatorsResponse.data?.length ?? 0,
    reportsCount: reportsResponse.data?.length ?? 0,
    recentStudents: students.take(5).toList(),
    recentTeachers: teachers.take(5).toList(),
    recentBookings: bookings.take(5).toList(),
  );
});

class DashboardData {
  const DashboardData({
    required this.studentsCount,
    required this.teachersCount,
    required this.bookingsCount,
    required this.subjectsCount,
    required this.evaluationsCount,
    required this.ratingsCount,
    required this.justificativesCount,
    required this.documentsCount,
    required this.moderatorsCount,
    required this.reportsCount,
    required this.recentStudents,
    required this.recentTeachers,
    required this.recentBookings,
  });

  final int studentsCount;
  final int teachersCount;
  final int bookingsCount;
  final int subjectsCount;
  final int evaluationsCount;
  final int ratingsCount;
  final int justificativesCount;
  final int documentsCount;
  final int moderatorsCount;
  final int reportsCount;
  final List<Student> recentStudents;
  final List<Teacher> recentTeachers;
  final List<Booking> recentBookings;
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const MyAppBar(subScreen: 'Dashboard'),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ref.watch(dashboardDataProvider).when(
              data: (dashboard) {
                return ListView(
                  children: [
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _MetricCard(
                          title: 'Students',
                          value: dashboard.studentsCount,
                          color: Colors.blue,
                        ),
                        _MetricCard(
                          title: 'Teachers',
                          value: dashboard.teachersCount,
                          color: Colors.indigo,
                        ),
                        _MetricCard(
                          title: 'Bookings',
                          value: dashboard.bookingsCount,
                          color: Colors.teal,
                        ),
                        _MetricCard(
                          title: 'Subjects',
                          value: dashboard.subjectsCount,
                          color: Colors.green,
                        ),
                        _MetricCard(
                          title: 'Evaluations',
                          value: dashboard.evaluationsCount,
                          color: Colors.orange,
                        ),
                        _MetricCard(
                          title: 'Ratings',
                          value: dashboard.ratingsCount,
                          color: Colors.amber.shade800,
                        ),
                        _MetricCard(
                          title: 'Justificatives',
                          value: dashboard.justificativesCount,
                          color: Colors.purple,
                        ),
                        _MetricCard(
                          title: 'Documents',
                          value: dashboard.documentsCount,
                          color: Colors.deepPurple,
                        ),
                        _MetricCard(
                          title: 'Moderators',
                          value: dashboard.moderatorsCount,
                          color: Colors.cyan.shade700,
                        ),
                        _MetricCard(
                          title: 'Reports',
                          value: dashboard.reportsCount,
                          color: Colors.red,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _RecentSection<Student>(
                      title: 'Recent Students',
                      items: dashboard.recentStudents,
                      itemBuilder: (student) =>
                          '${student.firstName ?? ''} ${student.lastName ?? ''} (${student.email ?? ''})'
                              .trim(),
                    ),
                    const SizedBox(height: 12),
                    _RecentSection<Teacher>(
                      title: 'Recent Teachers',
                      items: dashboard.recentTeachers,
                      itemBuilder: (teacher) =>
                          '${teacher.firstName ?? ''} ${teacher.lastName ?? ''} (${teacher.email ?? ''})'
                              .trim(),
                    ),
                    const SizedBox(height: 12),
                    _RecentSection<Booking>(
                      title: 'Recent Bookings',
                      items: dashboard.recentBookings,
                      itemBuilder: (booking) {
                        final format = DateFormat('yyyy-MM-dd HH:mm');
                        final start = booking.startDate == null
                            ? '-'
                            : format.format(booking.startDate!.toLocal());
                        final studentName =
                            '${booking.student?.firstName ?? ''} ${booking.student?.lastName ?? ''}'
                                .trim();
                        final teacherName =
                            '${booking.teacher?.firstName ?? ''} ${booking.teacher?.lastName ?? ''}'
                                .trim();
                        return '$start | ${booking.schoolSubject?.name ?? '-'} | $studentName -> $teacherName';
                      },
                    ),
                  ],
                );
              },
              error: (error, stackTrace) {
                return Center(
                  child: Text('Error loading dashboard: $error'),
                );
              },
              loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                value.toString(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentSection<T> extends StatelessWidget {
  const _RecentSection({
    required this.title,
    required this.items,
    required this.itemBuilder,
  });

  final String title;
  final List<T> items;
  final String Function(T item) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            if (items.isEmpty) const Text('No records'),
            if (items.isNotEmpty)
              ...items.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(itemBuilder(item)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
