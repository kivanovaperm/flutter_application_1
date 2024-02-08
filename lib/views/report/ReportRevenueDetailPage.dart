import 'package:flutter_application_1/models/reportRevenue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/sidebar/SideBarPage.dart';

import '../../controllers/revenue_report_controller.dart';
import 'ReportRevenuePage.dart';

class ReportRevenueDetailPage extends StatefulWidget {
  final String startDate;
  final String endDate;
  ReportRevenueDetailPage({required this.startDate, required this.endDate})
      : super();

  @override
  _ReportRevenueDetailPageState createState() =>
      _ReportRevenueDetailPageState();
}

class _ReportRevenueDetailPageState extends State<ReportRevenueDetailPage> {
  List<ReportRevenue> _reportRevenues = [];
  final RevenueReportController _revenueReportController =
      RevenueReportController();

  @override
  void initState() {
    super.initState();
    fetchReport(widget.startDate, widget.endDate);
  }

  Future<List<ReportRevenue>> fetchReport(
      String startDate, String endDate) async {
    final controller = RevenueReportController();
    final revenueReports = await controller.reportRevenues(startDate, endDate);

    return revenueReports;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: const Text("Доходы"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<ReportRevenue>>(
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
                        MaterialPageRoute(builder: (_) => ReportRevenuePage()),
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
            List<ReportRevenue> reportRevenues = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                for (ReportRevenue reportRevenue in reportRevenues)
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20, left: 20),
                        child: Text(
                          'Категория: ${reportRevenue.categoryName}\n'
                          'Разница: ${double.parse(reportRevenue.difference!)}\n'
                          'Итого: ${reportRevenue.totalSum}',
                          style: TextStyle(
                            fontSize: 18,
                            color: double.parse(reportRevenue.difference!) < 0
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
                        MaterialPageRoute(builder: (_) => ReportRevenuePage()),
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
