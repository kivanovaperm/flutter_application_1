import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/expenditure_controller.dart';
import 'package:flutter_application_1/models/expenditure.dart';
import 'package:flutter_application_1/views/expenditure/expenditureListPage.dart';

import '../../models/category.dart';

class ExpenditureDetail extends StatefulWidget {
  final int id;

  const ExpenditureDetail({Key? key, required this.id}) : super(key: key);

  @override
  _ExpenditureDetailState createState() => _ExpenditureDetailState();
}

class _ExpenditureDetailState extends State<ExpenditureDetail> {
  final ExpenditureController _expenditureController = ExpenditureController();
  final TextEditingController _sumcontroller = TextEditingController();
  final TextEditingController _categorycontroller = TextEditingController();
  final TextEditingController _createdcontroller = TextEditingController();
  final TextEditingController _idcontroller = TextEditingController();
  final TextEditingController _expendituredatecontroller =
      TextEditingController();

  List<RevenueCategory> _categories = [];
  List<String> expenditureTypes = ["КАРТА", "НАЛИЧНЫЕ"];

  String _selectedCategory = "";
  String _selectedExpenditureType = "";
  int _selectedCategoryId = 0;

  Expenditure? _expenditure;

  @override
  void initState() {
    super.initState();
    fetchExpenditureDetail();
    fetchCategories();
  }

  void fetchExpenditureDetail() async {
    try {
      Expenditure fetchedExpenditure =
          await _expenditureController.fetchExpenditureDetail(widget.id);
      setState(() {
        _expenditure = fetchedExpenditure;
        _idcontroller.text = _expenditure!.id.toString();
        _sumcontroller.text = _expenditure!.sum.toString();
        _categorycontroller.text = _expenditure!.category!.name.toString();
        _createdcontroller.text = _expenditure!.createdAt.toString();
        _expendituredatecontroller.text =
            _expenditure!.expenditureDate.toString();

        _selectedCategory = _expenditure!.category!.name.toString();
        _selectedCategoryId = _expenditure!.category!.id!.toInt();
        _selectedExpenditureType = _expenditure!.expenditureType!;
      });
    } catch (e) {
      print('Error fetching expenditures: $e');
    }
  }

  void fetchCategories() async {
    try {
      List<RevenueCategory> categories =
          await _expenditureController.fetchCategories();

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
        title: const Text("Расход"),
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
              controller: _expendituredatecontroller,
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  setState(() {
                    _expendituredatecontroller.text =
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
                  int idToDelete = int.parse(_idcontroller.text); // ID;
                  // Вызываем метод удаления из контроллера
                  final bool isDeleted = await _expenditureController
                      .deleteExpenditure(idToDelete);
                  if (isDeleted) {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => ExpenditureListPage()),
                    );
                  } else {}
                } catch (e) {
                  // Обработка ошибок удаления
                  print('Error deleting expenditure: $e');
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
                  String updatedExpenditureDate =
                      _expendituredatecontroller.text;

                  String updatedExpanditureType = _selectedExpenditureType;
                  final bool? isUpdated =
                      await _expenditureController.updateExpenditure(
                          idToUpdate,
                          updatedSum,
                          _selectedCategoryId,
                          updatedExpenditureDate,
                          _selectedExpenditureType);
                  if (isUpdated!) {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => ExpenditureListPage()),
                    );
                  } else {}
                } catch (e) {
                  // Обработка ошибок при обновлении
                  print('Error updating expenditure: $e');
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
