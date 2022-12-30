import 'dart:async';

import 'package:stacked/stacked.dart';

class TestViewModel extends BaseViewModel {
  double valuee = 1;
  onUpdateValue() {
    // value = 80;

    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (valuee >= 0) {
        valuee++;
        notifyListeners();
      } else {
        valuee = 0;
        notifyListeners();
      }
    });
  }
}
