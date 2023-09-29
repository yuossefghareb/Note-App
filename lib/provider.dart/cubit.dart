import 'package:flutter/material.dart';

class MyModel with ChangeNotifier {
  bool abs = true;
  IconData icon = Icons.remove_red_eye;
  chnageabs() {
    abs = !abs;
    if (abs)
      icon = Icons.visibility_off;
    else
      icon = Icons.visibility;
    notifyListeners();
  }
}
