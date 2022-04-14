import 'package:flutter/cupertino.dart';

class PackageContentService with ChangeNotifier {
  List<String> selectedContents = [];

  addContent(String id) {
    try {
      if (!selectedContents.contains(id)) {
        selectedContents.add(id);
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  removeContent(String id) {
    try {
      if (selectedContents.contains(id)) {
        selectedContents.remove(id);
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  getSelectedContents() => selectedContents;
}
