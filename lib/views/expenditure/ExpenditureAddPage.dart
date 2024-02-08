import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/expenditure_controller.dart';
import 'package:flutter_application_1/models/expenditure.dart';
import 'package:flutter_application_1/views/expenditure/ExpenditureListPage.dart';

import '../../models/category.dart';

class ExpenditureAddPage extends StatefulWidget {
  ExpenditureAddPage({super.key});

  @override
  _ExpenditureAddPageState createState() => _ExpenditureAddPageState();
}

class _ExpenditureAddPageState extends State<ExpenditureAddPage> {
  final ExpenditureController _expenditureController = ExpenditureController();
  final TextEditingController _sumcontroller = TextEditingController();
  final TextEditingController _categorycontroller = TextEditingController();
  final TextEditingController _createdcontroller = TextEditingController();
  final TextEditingController _idcontroller = TextEditingController();
  final TextEditingController _expenditureDatecontroller =
      TextEditingController();

  List<RevenueCategory> _categories = [];

  String _selectedCategory = "";
  String _selectedExpenditureType = "КАРТА";
  int _selectedCategoryId = 0;

  Expenditure? _expenditure;

  List<String> expenditureTypes = ["КАРТА", "НАЛИЧНЫЕ"];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void fetchCategories() async {
    try {
      List<RevenueCategory> categories =
          await _expenditureController.fetchCategories();

      setState(() {
        _categories = categories;
        _selectedCategory = _categories[0].name.toString();
        _selectedCategoryId =
            _categories[0].id != null ? _categories[0].id! : 0;
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Добавить расход"),
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
            child: DropdownButton<String>(
              value: _selectedExpenditureType,
              isExpanded: true,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
              hint: Container(
                child: Text("Выберите тип"),
              ),
              items: expenditureTypes.map((expenditureType) {
                return DropdownMenuItem<String>(
                  value: expenditureType,
                  child: Text(
                    expenditureType,
                    style: TextStyle(fontSize: 15),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedExpenditureType = newValue!;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              readOnly: true,
              controller: _expenditureDatecontroller,
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  setState(() {
                    _expenditureDatecontroller.text =
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
                  int selectedCategoryId = _categories
                      .firstWhere(
                          (category) => category.name == _selectedCategory)
                      .id!;
                  double? updatedSum = double.tryParse(_sumcontroller.text);
                  String expenditureType = _selectedExpenditureType;
                  String expenditureDate = _expenditureDatecontroller.text;
                  final bool? isCreated =
                      await _expenditureController.createExpenditure(
                          updatedSum!,
                          _selectedCategoryId,
                          expenditureType,
                          expenditureDate);
                  if (isCreated!) {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => ExpenditureListPage()),
                    );
                  } else {}
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
