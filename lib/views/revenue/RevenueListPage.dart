import 'package:flutter_application_1/views/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/revenue.dart';
import 'package:flutter_application_1/controllers/revenue_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/revenue_controller.dart';
import 'package:flutter_application_1/views/revenue/RevenueDetail.dart';
import 'package:flutter_application_1/views/revenue/RevenueAddPage.dart';
import 'package:flutter_application_1/views/sidebar/SideBarPage.dart';

class RevenuePage extends StatefulWidget {
  RevenuePage({Key? key}) : super(key: key);

  @override
  _RevenuePageState createState() => _RevenuePageState();
}

class _RevenuePageState extends State<RevenuePage> {
  List<Revenue> revenues = [];
  final RevenueController _revenueController = RevenueController();

  @override
  void initState() {
    super.initState();
    fetchRevenues();
  }

  void fetchRevenues() async {
    try {
      List<Revenue> fetchedRevenues = await _revenueController.fetchRevenues();
      setState(() {
        revenues = fetchedRevenues;
      });
    } catch (e) {
      print('Error fetching revenues: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isListEmpty = revenues.isEmpty;

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: const Text("Доходы"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (isListEmpty)
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Нет доходов за текущий день',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(10),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RevenueAddPage()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.black),
                ),
                child: Text(
                  '+ Добавить доход',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            if (!isListEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: revenues.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RevenueDetail(id: revenues[index].id!),
                          ),
                        );
                      },
                      subtitle:
                          Text('Сумма: ${revenues[index].sum.toString()}'),
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
