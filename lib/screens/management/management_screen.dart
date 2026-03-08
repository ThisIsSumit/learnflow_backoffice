import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:learnflow_backoffice/screens/home/widgets/app_bar.dart';
import 'package:learnflow_backoffice/screens/management/widgets/booking_data_table.dart';
import 'package:learnflow_backoffice/screens/management/widgets/document_data_table.dart';
import 'package:learnflow_backoffice/screens/management/widgets/evaluation_data_table.dart';
import 'package:learnflow_backoffice/screens/management/widgets/manager_data_table.dart';
import 'package:learnflow_backoffice/screens/management/widgets/moderator_data_table.dart';
import 'package:learnflow_backoffice/screens/management/widgets/payment_data_table.dart';
import 'package:learnflow_backoffice/screens/management/widgets/rating_data_table.dart';
import 'package:learnflow_backoffice/screens/management/widgets/report_data_table.dart';
import 'package:learnflow_backoffice/screens/management/widgets/report_type_data_table.dart';
import 'package:learnflow_backoffice/screens/management/widgets/school_subject_data_table.dart';
import 'package:learnflow_backoffice/screens/management/widgets/school_subject_taught_data_table.dart';
import 'package:learnflow_backoffice/screens/management/widgets/student_data_table.dart';
import 'package:learnflow_backoffice/screens/management/widgets/table_selector.dart';
import 'package:learnflow_backoffice/screens/management/widgets/teacher_data_table.dart';
import 'package:learnflow_backoffice/screens/management/widgets/justificative_data_table.dart';

final dataTableIndexProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});

class ManagementScreen extends ConsumerWidget {
  const ManagementScreen({super.key});

  static const dataTable = [
    StudentDataTable(),
    TeacherDataTable(),
    BookingDataTable(),
    SchoolSubjectDataTable(),
    EvaluationDataTable(),
    RatingDataTable(),
    JustificativeDataTable(),
    DocumentDataTable(),
    ModeratorDataTable(),
    ReportDataTable(),
    PaymentDataTable(),
    ManagerDataTable(),
    ReportTypeDataTable(),
    SchoolSubjectTaughtDataTable(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const MyAppBar(subScreen: "Management"),
        const Flexible(child: TableSelector()),
        Expanded(
          flex: 5,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: dataTable[ref.watch(dataTableIndexProvider)],
          ),
        ),
      ],
    );
  }
}
