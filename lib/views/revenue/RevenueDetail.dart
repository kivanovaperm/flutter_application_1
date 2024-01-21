import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/revenue_controller.dart';
import 'package:flutter_application_1/models/revenue.dart';
import 'package:flutter_application_1/views/revenue/RevenueListPage.dart';

import '../../models/category.dart';

class RevenueDetail extends StatefulWidget {
  final int id;

  const RevenueDetail({Key? key, required this.id}) : super(key: key);

  @override
  _RevenueDetailState createState() => _RevenueDetailState();
}

class _RevenueDetailState extends State<RevenueDetail> {
  final RevenueController _revenueController = RevenueController();
  final TextEditingController _sumcontroller = TextEditingController();
  final TextEditingController _categorycontroller = TextEditingController();
  final TextEditingController _createdcontroller = TextEditingController();
  final TextEditingController _idcontroller = TextEditingController();
  final TextEditingController _revenuedatecontroller = TextEditingController();

  List<RevenueCategory> _categories = [];

  String _selectedCategory = "";
  int _selectedCategoryId = 0;

  Revenue? _revenue;

  @override
  void initState() {
    super.initState();
    fetchRevenueDetail();
    fetchCategories();
  }

  void fetchRevenueDetail() async {
    try {
      Revenue fetchedRevenues =
          await _revenueController.fetchRevenueDetail(widget.id);
      setState(() {
        _revenue = fetchedRevenues;
        _sumcontroller.text = _revenue!.sum.toString();
        _categorycontroller.text = _revenue!.category!.name.toString();
        _createdcontroller.text = _revenue!.createdAt.toString();
        _revenuedatecontroller.text = _revenue!.revenueDate.toString();
        _idcontroller.text = _revenue!.id.toString();

        _selectedCategory = _revenue!.category!.name.toString();
        _selectedCategoryId = _revenue!.category!.id!.toInt();
      });
    } catch (e) {
      print('Error fetching revenues: $e');
    }
  }

  void fetchCategories() async {
    try {
      // Получение списка категорий из базы данных или другого источника
      List<RevenueCategory> categories =
          await _revenueController.fetchCategories();

      setState(() {
        _categories = categories;
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Доходы"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: _sumcontroller,
              decoration: InputDecoration(
                labelText: ' Сумма',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
              hint: Container(
                child: Text("Выберите категорию"),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category.name,
                  child: Text(
                    category.name!,
                    style: TextStyle(fontSize: 15),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                for (var i = 0; i < _categories.length; i++) {
                  if (_categories[i].name == newValue) {
                    _selectedCategoryId = _categories[i].id!;
                  }
                }
                setState(() {
                  _selectedCategory = newValue ?? "";
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              readOnly: true,
              controller: _revenuedatecontroller,
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  setState(() {
                    _revenuedatecontroller.text =
                        selectedDate.toLocal().toString().split(' ')[0];
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Дата',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: OutlinedButton(
              onPressed: () async {
                try {
                  // Получаем ID элемента, который нужно удалить
                  int idToDelete = int.parse(_idcontroller.text); // ваш ID;

                  // Вызываем метод удаления из контроллера
                  final bool isDeleted =
                      await _revenueController.deleteRevenue(idToDelete);
                  if (isDeleted) {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => RevenuePage()),
                    );
                  } else {
                    // Обработка неудачного удаления
                  }
                } catch (e) {
                  // Обработка ошибок удаления
                  print('Error deleting revenue: $e');
                }
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.black),
                minimumSize: Size(double.infinity, 40),
              ),
              child: Text(
                'Удалить',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: OutlinedButton(
              onPressed: () async {
                try {
                  int idToUpdate = int.parse(_idcontroller.text);
                  String updatedSum = _sumcontroller.text;
                  String updatedRevenueDate = _revenuedatecontroller.text;
                  final bool isUpdated = await _revenueController.updateRevenue(
                      idToUpdate,
                      updatedSum,
                      _selectedCategoryId,
                      updatedRevenueDate);
                  if (isUpdated) {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => RevenuePage()),
                    );
                  } else {
                    // Обработка неудачного обновления
                  }
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
                'Обновить',
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
