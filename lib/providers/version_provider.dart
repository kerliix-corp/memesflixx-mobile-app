import 'package:flutter/material.dart';

class VersionProvider extends ChangeNotifier {
  bool _forceUpdate = false;
  bool get forceUpdate => _forceUpdate;

  void setForceUpdate(bool value) {
    _forceUpdate = value;
    notifyListeners();
  }
}