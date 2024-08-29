import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../data/data_provider.dart';
import '../utils/file_utils.dart'; // Импортируем утилиту

class ServiceScreen extends StatefulWidget {
  final DataProvider dataProvider;

  ServiceScreen({required this.dataProvider});

  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Сервисные функции'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                String jsonData = await widget.dataProvider.exportDataToJson();
                File jsonFile = await saveJsonToFile(jsonData);
                _shareJsonFile(jsonFile);
              },
              child: Text('Поделиться данными'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String? jsonData = await loadJsonFromFile();
                if (jsonData != null) {
                  await widget.dataProvider.importDataFromJson(jsonData);
                  await widget.dataProvider.loadProducts();
                  setState(() {
                    // Этот вызов заставит Flutter перерисовать экран с новыми данными
                  });
                  _showMessage(context, 'Данные успешно загружены');
                } else {
                  _showMessage(context, 'Ошибка загрузки файла');
                }
              },
              child: Text('Загрузить данные'),
            ),
          ],
        ),
      ),
    );
  }

  Future<File> saveJsonToFile(String jsonData) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.json');
    await file.writeAsString(jsonData);
    return file;
  }

  void _shareJsonFile(File file) {
    // Создаем объект XFile
    final xFile = XFile(file.path);
    Share.shareXFiles([xFile], text: 'Данные из приложения');
  }

  void _showMessage(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
