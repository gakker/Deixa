import 'package:flutter/foundation.dart';

class BaseChangeNotifier<T> extends ChangeNotifier {
  T? view;
  bool _loading = false;

  bool get loading => _loading;

  set loading(bool val) {
    _loading = val;
    notifyListeners();
  }

  void attachView(T view) {
    this.view = view;
  }

  void detachView() {
    view = null;
  }
}
