import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/revenue_controller.dart';
import 'package:flutter_application_1/models/revenue.dart';

class RevenuePage extends StatefulWidget {
  RevenuePage({Key? key}) : super(key: key);

  @override
  State<RevenuePage> createState() => _RevenuePageState();
}

class _RevenuePageState extends State<RevenuePage> {
  final RevenueController _revenueController = RevenueController();
  late Future<List<Revenue>> _revenueList;

  @override
  void initState() {
    super.initState();
    _loadRevenueList();
  }

  Future<void> _loadRevenueList() async {
    _revenueList = _revenueController.fetchRevenues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Доходы'),
      ),
      body: Center(
        child: FutureBuilder<List<Revenue>>(
          future: _revenueList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No data available');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Revenue revenue = snapshot.data![index];
                  // Возвращаем виджет с информацией о доходе
                  return ListTile(
                    title: Text('Сумма: ${revenue.sum}'),
                    subtitle: Text('Дата: ${revenue.revenueDate}'),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
