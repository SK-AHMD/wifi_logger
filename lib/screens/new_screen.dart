import 'package:flutter/material.dart';
import 'package:wifi/database/user_data.dart';

class UserListWidget extends StatefulWidget {
  @override
  _UserListWidgetState createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<UserListWidget> {
  final UserDatabase db = UserDatabase();
  List<String> userNames = [];
  String selectedUsername = '';
  @override
  void initState() {
    super.initState();
    _loadUsernames();
  }

  Future<void> _loadUsernames() async {
    db.createInitialData();
    setState(() {
      userNames = db.getUsernames();
      if (userNames.isNotEmpty) {
        selectedUsername = userNames.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Usernames List'),
        ),
        body: Center(
          child: Column(
            children: [
              DropdownButton<String>(
                value: selectedUsername,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedUsername = newValue!;
                  });
                },
                items: userNames.map((String username) {
                  return DropdownMenuItem<String>(
                    value: username,
                    child: Text(username),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Text(
                'Selected Username: $selectedUsername',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ));
  }
}
