import 'package:flutter/material.dart';
import 'package:financial_management/controllers/expenditure_controller.dart';
import 'package:financial_management/models/expenditure.dart';
import 'package:financial_management/views/expenditure/expenditureListPage.dart';

import '../../models/category.dart';
import '../sidebar/SideBarPage.dart';

class ExpenditureQRDetailPage extends StatefulWidget {
  final String url;

  const ExpenditureQRDetailPage(this.url, {Key? key}) : super(key: key);

  @override
  _ExpenditureQRDetailPageState createState() => _ExpenditureQRDetailPageState();
}

class _ExpenditureQRDetailPageState extends State<ExpenditureQRDetailPage> {
  final TextEditingController _expenditureQRDetailPageState =
      TextEditingController();
  final ExpenditureController _expenditureController = ExpenditureController();
  late Map<String, String> decodedData;
  late String date;
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
    decodedData = decodeUrl(widget.url);
    date = decodeDate(decodedData['t'] ?? '');
  }
 

  void fetchCategories() async {
    try {
      // Получение списка категорий из базы данных или другого источника
      List<RevenueCategory> categories =
          await _expenditureController.fetchCategories();

      setState(() {
        _categories = categories;
        _selectedCategory = _categories[0].name.toString();
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Отсканированный чек')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top:20,bottom: 10, left: 15),
              child: Text(
                "Дата: $date",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
             Divider(thickness: 2.0,), // Add a divider between data elements
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                " Сумма: ${decodedData['s']}",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            Divider(thickness: 2.0,), // Add a divider between data elements
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
              padding: EdgeInsets.only(top:10,left:100),
              child: OutlinedButton(
                onPressed: () async {
                  try {
                    int selectedCategoryId = _categories
                        .firstWhere((category) =>
                            category.name == _selectedCategory)
                        .id!;
                    double? updatedSum = double.tryParse(decodedData['s']!);
                    String expenditureType = _selectedExpenditureType;
                    String expenditureDate = date;
                    final bool? isCreated = await _expenditureController.createExpenditure(
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
                ),
                child: Text(
                  'Добавить в расходы',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, String> decodeUrl(String url) {
    Map<String, String> decodedData = {};
    List<String> pairs = url.split('&');

    for (String pair in pairs) {
      List<String> keyValue = pair.split('=');
      if (keyValue.length == 2) {
        String key = keyValue[0];
        String value = keyValue[1];
        decodedData[key] = value;
      }
    }

    return decodedData;
  }

  String decodeDate(String encodedDate) {
    String year = encodedDate.substring(0, 4);
    String month = encodedDate.substring(4, 6);
    String day = encodedDate.substring(6, 8);
    return '$year-$month-$day';
  }
}
