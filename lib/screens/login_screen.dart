import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wifi/database/user_data.dart';
import 'package:wifi/service/wifi.dart';
import 'package:wifi/utils.dart';

import '../functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> data = {};
  final _myBox = Hive.box('bb');
  final GlobalKey _dropdownKey = GlobalKey();
  UserDatabase db = UserDatabase();
  List<String> userNames = [];
  String selectedItem = '';
  @override
  void initState() {
    // TODO: implement initState
    _loadUsernames();

    super.initState();
  }

  // load username
  Future<void> _loadUsernames() async {
    if (_myBox.get('USERDATA') == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    _updateUsernames(); // Initial load
  }

  Future<void> _updateUsernames() async {
    final List<String> updatedUsernames = db.getUsernames();
    setState(() {
      userNames = updatedUsernames;
      if (userNames.isNotEmpty) {
        selectedItem = userNames.first;
      }
    });

    // Rebuild the DropdownButton
    if (_dropdownKey.currentContext != null) {
      BuildContext? dropdownContext = _dropdownKey.currentContext;
      if (dropdownContext != null) {
        Scaffold.of(dropdownContext).setState(() {});
      }
    }
  }

  void _handleAddUser(String newUsername, String pass) async {
    // Example: Add a new user with a unique username

    db.addUser(newUsername, pass);
    showToast('Account Added', context);
    await _updateUsernames(); // Update the list after adding a new user
  }

  // update usernames list

  // Define a variable to hold the selected item
  void _showAlertDialog(BuildContext context) {
    // Controllers for the TextFields to capture user input
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add account',
            style: textStyle(20, Colors.white, FontWeight.w500),
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * .18,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                // Username TextField
                TextField(
                  style: const TextStyle(
                    color: Colors.white, // Set text color
                  ),
                  controller: usernameController,
                  decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      labelText: 'Username',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),

                // Password TextField
                TextField(
                  style: const TextStyle(
                    color: Colors.white, // Set text color
                  ),
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          actions: [
            // Cancel Button
            TextButton(
                onPressed: () {
                  // Close the AlertDialog
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: textStyle(16, Colors.white, FontWeight.normal),
                )),

            // OK Button
            TextButton(
                onPressed: () {
                  _handleAddUser(
                      usernameController.text, passwordController.text);
                  // Close the AlertDialog
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Add',
                  style: textStyle(16, Colors.white, FontWeight.normal),
                )),
          ],
          elevation: 20,
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 15, 22, 41),
                Color.fromARGB(255, 59, 60, 61),
              ],
              begin: FractionalOffset(0.0, 1.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(22),
                    height: 160,
                    width: 160,
                    child: Image.asset(
                      'images/wifi_orange.png',
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Text(
                'Hostel wifi logger',
                style: textStyle(24, Colors.white, FontWeight.normal),
              ),
              const SizedBox(
                height: 30,
              ),
              if (data['message'] != null)
                Text(
                  data['message'],
                  style: textStyle(23, Colors.white, FontWeight.w300),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white, width: 1.5),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(1, 1),
                          blurRadius: 4,
                          spreadRadius: 0.5,
                        ),
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(-1, -1),
                          blurRadius: 4,
                          spreadRadius: 0.5,
                        ),
                      ]),
                  child: Builder(
                      key: _dropdownKey,
                      builder: (BuildContext context) {
                        return DropdownButton<String>(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          iconSize: 30,
                          underline: const SizedBox(),
                          isExpanded: true,
                          dropdownColor: Colors.black26,
                          value: selectedItem,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedItem = newValue!;
                            });
                          },
                          items: userNames.map((String username) {
                            return DropdownMenuItem<String>(
                              alignment: AlignmentDirectional.centerStart,
                              value: username,
                              child: Text(
                                username,
                                style: textStyle(
                                    20, Colors.white, FontWeight.w500),
                              ),
                            );
                          }).toList(),
                        );
                      }),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  data = await WifiApiService.sendWifiApiRequest(selectedItem);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.38,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(1, 1),
                          blurRadius: 10,
                          spreadRadius: 1.0,
                        ),
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(-1, -1),
                          blurRadius: 10,
                          spreadRadius: 1.0,
                        ),
                      ]),
                  child: Center(
                    child: Text(
                      "Log In",
                      style: textStyle(24, Colors.black, FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Add User',
            backgroundColor: Colors.white,
            onPressed: () {
              _showAlertDialog(context);
            },
            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(12),
                height: 80,
                child: Image.asset(
                  'images/add-user.png',
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
