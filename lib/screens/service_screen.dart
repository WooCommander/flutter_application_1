import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import '../data/data_provider.dart';
import '../utils/file_utils.dart'; // Импортируем утилиту

class ServiceScreen extends StatelessWidget {
  final DataProvider dataProvider;

  ServiceScreen({required this.dataProvider});

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
                String jsonData = await dataProvider.exportDataToJson();
                File jsonFile = await saveJsonToFile(jsonData);
                _shareJsonFile(jsonFile);
              },
              child: Text('Выгрузить и поделиться данными'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String? jsonData = await loadJsonFromFile();
                if (jsonData != null) {
                  await dataProvider.importDataFromJson(jsonData);
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
    Share.shareFiles([file.path], text: 'Данные из приложения');
  }

  void _showMessage(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
