import 'package:flutter/cupertino.dart';

class CountProvider with ChangeNotifier {
  int _counter = 0;
  int get count => _counter;

  String _utitle = "YOurs";
  String get utitle => _utitle;

  String _ctitle = "Create";
  String get ctitle => _utitle;

  bool _hasData = false;
  bool get hasData => _hasData;
  void updateHasData(bool hasData) {
    _hasData = hasData;
    notifyListeners();
  }

  void incrementCounter() {
    _counter++;
    notifyListeners();
  }

  void decremenCounter() {
    _counter--;
    notifyListeners();
  }

  // static ValueNotifier<bool> _isDataAvailablee = ValueNotifier<bool>(false);
  // ValueNotifier<bool> get isDataAvailable => _isDataAvailablee;
}
