import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wifi/screens/logout_screen.dart';
import 'package:wifi/service/wifi.dart';
import 'package:wifi/utils.dart';

import '../database/user_data.dart';
import '../functions.dart';

class LoginScreen extends StatefulWidget {
  final String message;
  const LoginScreen({super.key, required this.message});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Map<String, dynamic> data = {};
  final _myBox = Hive.box('bb');
  final GlobalKey _dropdownKey = GlobalKey();
  UserDatabase db = UserDatabase();
  List<String> userNames = [];
  String selectedItem = '';
  String mess = '';
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
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/dark_background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: FadeInUp(
                            duration: const Duration(milliseconds: 600),
                            child: Container(
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('images/light-1.png'))),
                            )),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeInUp(
                            duration: const Duration(milliseconds: 900),
                            child: Container(
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('images/light-2.png'))),
                            )),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeInUp(
                            duration: const Duration(milliseconds: 1100),
                            child: Container(
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('images/clock.png'))),
                            )),
                      ),
                      Positioned(
                        child: FadeInUp(
                            duration: const Duration(milliseconds: 1300),
                            child: Container(
                              margin: const EdgeInsets.only(top: 50),
                              child: Center(
                                child: Text(
                                  "Hostel Wifi Login",
                                  style: textStyle(
                                      24, Colors.white, FontWeight.normal),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                Text(
                  mess,
                  style: textStyle(23, Colors.black, FontWeight.normal),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      FadeInUp(
                          duration: const Duration(milliseconds: 600),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color:
                                        const Color.fromRGBO(143, 148, 251, 1)),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color.fromRGBO(143, 148, 251, .2),
                                      blurRadius: 20.0,
                                      offset: Offset(0, 10))
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Builder(
                                  key: _dropdownKey,
                                  builder: (BuildContext context) {
                                    return DropdownButton<String>(
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Colors.black,
                                      ),
                                      iconSize: 30,
                                      underline: const SizedBox(),
                                      isExpanded: true,
                                      dropdownColor: Colors.white,
                                      value: selectedItem,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedItem = newValue!;
                                        });
                                      },
                                      items: userNames.map((String username) {
                                        return DropdownMenuItem<String>(
                                          alignment:
                                              AlignmentDirectional.centerStart,
                                          value: username,
                                          child: Text(
                                            username,
                                            style: textStyle(20, Colors.black,
                                                FontWeight.w400),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  }),
                            ),
                          )),
                      const SizedBox(
                        height: 30,
                      ),
                      FadeInUp(
                          duration: const Duration(milliseconds: 800),
                          child: GestureDetector(
                            onTap: () async {
                              data = await WifiApiService.sendWifiApiRequest(
                                  selectedItem);
                              var currentUser = selectedItem;
                              if (data['message'] != null) {
                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (selectedItem) => LogoutScreen(
                                              currentUser: currentUser,
                                            )));
                              }
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(255, 27, 37, 67)),
                              child: const Center(
                                child: Text(
                                  "login",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )),
                      const SizedBox(
                        height: 70,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FadeInRight(
          duration: const Duration(milliseconds: 300),
          child: FloatingActionButton(
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
