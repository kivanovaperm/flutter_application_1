import 'package:flutter_application_1/views/HomePage.dart';
import 'package:flutter_application_1/views/report/ReportRevenuePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/revenue.dart';
import 'package:flutter_application_1/controllers/revenue_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/revenue_controller.dart';
import 'package:flutter_application_1/views/revenue/RevenueDetail.dart';
import 'package:flutter_application_1/views/revenue/RevenueAddPage.dart';
import 'package:flutter_application_1/views/sidebar/SideBarPage.dart';

class ReportPage extends StatefulWidget {
  ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: const Text("Отчет"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Отчеты',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ReportRevenuePage()),
                      );
                    },
                    subtitle: Text('Доходы'),
                  );
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RevenueAddPage()),
                      );
                    },
                    subtitle: Text('Расходы'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
