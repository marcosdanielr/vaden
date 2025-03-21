import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class MainViewmodel extends ChangeNotifier {
  late final setLanguageCommand = Command1<Unit, Locale>(_setLanguage);

  Locale _locale = Locale('en', 'US');
  Locale get locale => _locale;

  AsyncResult<Unit> _setLanguage(Locale locale) async {
    _locale = locale;
    notifyListeners();
    return Success(unit);
  }
}
