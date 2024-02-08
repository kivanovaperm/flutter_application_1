import 'package:flutter_application_1/models/reportRevenue.dart';
import 'package:flutter_application_1/views/report/ReportExpenditurePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/sidebar/SideBarPage.dart';

import '../../controllers/expenditure_report_controller.dart';
import '../../controllers/revenue_report_controller.dart';
import '../../models/reportExpenditure.dart';
import 'ReportRevenuePage.dart';

class ReportExpenditureDetailPage extends StatefulWidget {
  final String startDate;
  final String endDate;
  ReportExpenditureDetailPage({required this.startDate, required this.endDate})
      : super();

  @override
  _ReportExpenditureDetailPageState createState() =>
      _ReportExpenditureDetailPageState();
}

class _ReportExpenditureDetailPageState
    extends State<ReportExpenditureDetailPage> {
  List<ReportExpenditure> _reportExpenditures = [];
  final ExpenditureReportController _expenditureReportController =
      ExpenditureReportController();

  @override
  void initState() {
    super.initState();
    fetchReport(widget.startDate, widget.endDate);
  }

  Future<List<ReportExpenditure>> fetchReport(
      String startDate, String endDate) async {
    final controller = ExpenditureReportController();
    final expenditureReports =
        await controller.reportExpenditures(startDate, endDate);

    return expenditureReports;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: const Text("Расходы"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<ReportExpenditure>>(
        future: fetchReport(widget.startDate, widget.endDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Отчет пуст',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 20),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ReportExpenditurePage()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.black),
                    ),
                    child: Text(
                      'Назад',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            List<ReportExpenditure> reportExpenditures = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                for (ReportExpenditure reportExpenditure in reportExpenditures)
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20, left: 20),
                        child: Text(
                          'Категория: ${reportExpenditure.categoryName}\n'
                          'Разница: ${double.parse(reportExpenditure.difference!)}\n'
                          'Итого: ${reportExpenditure.totalSum}',
                          style: TextStyle(
                            fontSize: 18,
                            color:
                                double.parse(reportExpenditure.difference!) < 0
                                    ? Colors.red
                                    : Colors.green,
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 2.0,
                      ), // Add a divider between data elements
                    ],
                  ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ReportExpenditurePage()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.black),
                    ),
                    child: Text(
                      'Назад',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
