import 'package:flutter_application_1/views/report/ReportRevenueDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/expenditure_controller.dart';
import 'package:flutter_application_1/models/expenditure.dart';
import 'package:flutter_application_1/views/expenditure/ExpenditureListPage.dart';

import '../../controllers/revenue_report_controller.dart';
import '../../models/category.dart';
import '../sidebar/SideBarPage.dart';

class ReportRevenuePage extends StatefulWidget {
  ReportRevenuePage({super.key});

  @override
  _ReportRevenuePageState createState() => _ReportRevenuePageState();
}

class _ReportRevenuePageState extends State<ReportRevenuePage> {
  final TextEditingController _revenueReportStartDatecontroller =
      TextEditingController();
  final TextEditingController _revenueReportEndDatecontroller =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: const Text("Отчет по доходам"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              readOnly: true,
              controller: _revenueReportStartDatecontroller,
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  setState(() {
                    _revenueReportStartDatecontroller.text =
                        selectedDate.toLocal().toString().split(' ')[0];
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Начальная дата',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              readOnly: true,
              controller: _revenueReportEndDatecontroller,
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  setState(() {
                    _revenueReportEndDatecontroller.text =
                        selectedDate.toLocal().toString().split(' ')[0];
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Конечная дата',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: OutlinedButton(
              onPressed: () async {
                try {
                  String revenueReportStartDate =
                      _revenueReportStartDatecontroller.text;
                  String revenueReportEndDate =
                      _revenueReportEndDatecontroller.text;

                  // Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ReportRevenueDetailPage(
                            startDate: revenueReportStartDate,
                            endDate: revenueReportEndDate)),
                  );
                } catch (e) {
                  // Обработка ошибок при обновлении
                  print('Error updating revenue: $e');
                }
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.black),
                minimumSize: Size(double.infinity, 40),
              ),
              child: Text(
                'Добавить',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
