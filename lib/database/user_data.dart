import 'package:hive/hive.dart';
import 'package:wifi/model/user/user_model.dart';

class UserDatabase {
  Map<String, Map<String, dynamic>> userData = {};
  // reference our box
  final _myBox = Hive.box('bb');

  // run this method if this is the 1st time ever opening this app
  void createInitialData() {
    userData = {
      // the format should be like this
      // you can also change model and format by your own

      "username": {
        "date": "2023-12-15",
        "datausage": "0",
        "password": "password",
        "payload": {
          "mode": "191",
          "username": "username",
          "password": "password",
          "a": "1703570929233",
          "producttype": "0"
        }
      },
    };

    // Add default credentials to the box
    for (final entry in userData.entries) {
      final username = entry.key.toUpperCase();
      final credentials = entry.value;
      final userModel = UserModel(
        credentials["date"],
        credentials["datausage"],
        credentials["payload"],
      );
      _myBox.put(username, userModel);
    }
  }

  List<String> getUsernames() {
    return _myBox.keys.cast<String>().toList();
  }

  // load the data from database
  void loadData() {}

  void addUser(String username, String password) {
    if (!_myBox.containsKey(username)) {
      UserModel userDataModel = UserModel(
        "2023-12-25", // Default date

        "0", // Default data usage
        {
          "mode": "191",
          "username": username,
          "password": password,
          "a": "18344374",
          "producttype": "0",
        },
      );

      _myBox.put(username, userDataModel);
      print('User $username added successfully.');
    } else {
      print('User with username $username already exists.');
    }
  }

  // update the database
  void updateDataBase() {
    _myBox.put("USERDATA", userData as UserModel);
  }
}
