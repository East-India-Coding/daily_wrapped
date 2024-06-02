
import 'package:flutter/cupertino.dart';

class InteractionNotifier extends ChangeNotifier {
  bool isInteracting = false;

  setIsInteracting(bool val) {
    isInteracting = val;
    notifyListeners();
  }
}