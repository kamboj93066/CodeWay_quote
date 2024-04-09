import 'package:hive_flutter/hive_flutter.dart';

class FavDatabase {
  List favList = [];
  // referencing to the box
  final _myBox = Hive.box('mybox');

  // opening the app first time ever
  void createInitialData() {
    favList = _myBox.get("FAVLIST");
    // favList = [
    //   ["This is a fav1 Quote"],
    //   ["Do exercise"]
    // ];
  }

  // to load the data from the database
  void loadData() {
    favList = _myBox.get("FAVLIST");
  }

  // to update the data in the database
  void updateDataBase() {
    _myBox.put("FAVLIST", favList);
  }
  // Store the last update date as a String (ISO 8601 format)
  Future<void> storeLastUpdateDate(String date) async {
    final box = Hive.box('mybox');
    await box.put('lastUpdateDate', date);
  }

  Future<String?> getLastUpdateDate() async {
    final box = Hive.box('mybox');
    return box.get('lastUpdateDate');
  }
}
