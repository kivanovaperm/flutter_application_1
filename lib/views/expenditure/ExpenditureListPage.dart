import 'package:flutter_application_1/views/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/expenditure.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/expenditure_controller.dart';
import 'package:flutter_application_1/views/expenditure/ExpenditureDetail.dart';
import 'package:flutter_application_1/views/expenditure/ExpenditureAddPage.dart';
import 'package:flutter_application_1/views/sidebar/SideBarPage.dart';

import 'ExpenditureQrAddPage.dart';

class ExpenditureListPage extends StatefulWidget {
  ExpenditureListPage({Key? key}) : super(key: key);

  @override
  _ExpenditureListPageState createState() => _ExpenditureListPageState();
}

class _ExpenditureListPageState extends State<ExpenditureListPage> {
  List<Expenditure> _expenditures = [];
  final ExpenditureController _expenditureController = ExpenditureController();

  @override
  void initState() {
    super.initState();
    fetchExpenditures();
  }

  void fetchExpenditures() async {
    try {
      List<Expenditure> fetchedExpenditures =
          await _expenditureController.fetchExpenditures();
      setState(() {
        _expenditures = fetchedExpenditures;
      });
    } catch (e) {
      print('Error fetching expenditures: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isListEmpty = _expenditures.isEmpty;

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: const Text("Расходы"),
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
                  'Нет расходов за текущий день',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(10),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ExpenditureAddPage()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.black),
                ),
                child: Text(
                  '+ Добавить расход',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => QRViewExample()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.black),
                ),
                child: Text(
                  '+ Сканировать QR',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            if (!isListEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _expenditures.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ExpenditureDetail(id: _expenditures[index].id!),
                          ),
                        );
                      },
                      subtitle:
                          Text('Сумма: ${_expenditures[index].sum.toString()}'),
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
