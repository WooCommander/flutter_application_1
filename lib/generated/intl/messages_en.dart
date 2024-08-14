// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "addProduct": MessageLookupByLibrary.simpleMessage("Add Product"),
        "appTitle": MessageLookupByLibrary.simpleMessage("Price Tracker"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "clear": MessageLookupByLibrary.simpleMessage("Clear"),
        "clearData": MessageLookupByLibrary.simpleMessage("Clear All Data"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "confirmClearData": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to clear all data?"),
        "confirmDeleteProduct": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete the item?"),
        "deleteProduct": MessageLookupByLibrary.simpleMessage("Delete Product"),
        "editProduct": MessageLookupByLibrary.simpleMessage("Edit Product"),
        "mostPopularProduct":
            MessageLookupByLibrary.simpleMessage("Most Popular Product"),
        "noData": MessageLookupByLibrary.simpleMessage("No Data Available"),
        "quantity": MessageLookupByLibrary.simpleMessage("Quantity"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "unitPrice": MessageLookupByLibrary.simpleMessage("Unit Price")
      };
}
