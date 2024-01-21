import 'package:flutter_application_1/views/report/ReportRevenueDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/expenditure_controller.dart';
import 'package:flutter_application_1/models/expenditure.dart';
import 'package:flutter_application_1/views/expenditure/ExpenditureListPage.dart';

import '../../controllers/revenue_report_controller.dart';
import '../../models/category.dart';
import '../sidebar/SideBarPage.dart';
import 'ReportExpenditureDetailPage.dart';

class ReportExpenditurePage extends StatefulWidget {
  ReportExpenditurePage({super.key});

  @override
  _ReportExpenditurePageState createState() => _ReportExpenditurePageState();
}

class _ReportExpenditurePageState extends State<ReportExpenditurePage> {
  final TextEditingController _expenditureReportStartDatecontroller =
      TextEditingController();
  final TextEditingController _expenditureReportEndDatecontroller =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: const Text("Отчет по расходам"),
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
              controller: _expenditureReportStartDatecontroller,
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  setState(() {
                    _expenditureReportStartDatecontroller.text =
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
              controller: _expenditureReportEndDatecontroller,
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  setState(() {
                    _expenditureReportEndDatecontroller.text =
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
                // try {s
                String expenditureReportStartDate =
                    _expenditureReportStartDatecontroller.text;
                String expenditureReportEndDate =
                    _expenditureReportEndDatecontroller.text;

                // Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ReportExpenditureDetailPage(
                          startDate: expenditureReportStartDate,
                          endDate: expenditureReportEndDate)),
                );

                // } catch (e) {
                //   // Обработка ошибок при обновлении
                //   print('Error updating revenue: $e');
                // }
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
