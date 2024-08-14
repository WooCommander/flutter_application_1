// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "addProduct": MessageLookupByLibrary.simpleMessage("Добавить товар"),
        "appTitle": MessageLookupByLibrary.simpleMessage("Фиксатор цен"),
        "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
        "clear": MessageLookupByLibrary.simpleMessage("Очистить"),
        "clearData":
            MessageLookupByLibrary.simpleMessage("Очистить все данные"),
        "confirm": MessageLookupByLibrary.simpleMessage("Подтвердить"),
        "confirmClearData": MessageLookupByLibrary.simpleMessage(
            "Вы уверены, что хотите очистить все данные?"),
        "confirmDeleteProduct": MessageLookupByLibrary.simpleMessage(
            "Вы уверены, что хотите удалить товар?"),
        "deleteProduct": MessageLookupByLibrary.simpleMessage("Удалить товар"),
        "editProduct":
            MessageLookupByLibrary.simpleMessage("Редактировать товар"),
        "mostPopularProduct":
            MessageLookupByLibrary.simpleMessage("Самый популярный товар"),
        "noData": MessageLookupByLibrary.simpleMessage("Нет данных"),
        "quantity": MessageLookupByLibrary.simpleMessage("Количество"),
        "save": MessageLookupByLibrary.simpleMessage("Сохранить"),
        "unitPrice": MessageLookupByLibrary.simpleMessage("Цена за единицу")
      };
}
