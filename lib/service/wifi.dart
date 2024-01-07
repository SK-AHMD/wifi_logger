import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:wifi/functions.dart';
import 'package:xml/xml.dart' as xml;
import 'package:hive/hive.dart';
import 'package:wifi/model/user/user_model.dart';
import 'package:xml/xml.dart';

class WifiApiService {
  // user your own hostel wifi url
  static const String apiUrl = "http://172.16.1.1:8090/login.xml";

  static Future<Map<String, dynamic>> sendWifiApiRequest(
      String username) async {
    // Load login credentials from Hive
    var credentialsBox = Hive.box('bb');

    // Uncomment the line below if you need to add default credentials
    // addDefaultCredentials(credentialsBox);

    final UserModel? userModel = credentialsBox.get(username) as UserModel?;

    if (userModel == null) {
      return {"message": "Login credentials not found"};
    }

    // Convert UserModel to Map<String, dynamic>
    final Map<String, dynamic> credentials = userModel.toMap();
    // print(credentials);
    final Map<String, String> payloadData = credentials["payload"];
    final String newpayloaddata = encodeFormData(payloadData);
    // print(payloadData);
    final Map<String, String> headers = {
      'Accept-Encoding': 'gzip, deflate',
      'Accept-Language': 'en-US,en',
      'Connection': 'keep-alive',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Host': '172.16.1.1:8090',
      'Referer': 'http://172.16.1.1:8090/httpclient.html'
    };
    final response = await http.post(
      Uri.parse(apiUrl),
      body: newpayloaddata,
      headers: headers,
    );
    final status = response.body;
    // print(status);
    final doc = xml.XmlDocument.parse(status);

    final code_1 = doc.findElements("message").toString();

    if (code_1.contains("You are signed in as {username}")) {
      return {"message": "login successful"};
    } else if (code_1.contains("Your data transfer has been exceeded")) {
      // Data limit exceeded
      return {"message": "Data limit exceeded"};
    } else if (code_1.contains("Login failed. Invalid username/password")) {
      // Invalid username/password
      return {"message": "Invalid username/password"};
    } else if (code_1
        .contains("Login failed. You have reached the maximum login limit")) {
      // Maximum login limit reached
      return {"message": "Already using in another device"};
    } else {
      // Server not responding or unknown response
      return {"message": "Server not responding at this moment"};
    }
  }

  static Future<Map<String, dynamic>> sendLogoutRequest(String username) async {
    // Load login credentials from Hive

    const String url = "http://172.16.1.1:8090/login.xml";

    final Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Accept-Encoding": "gzip, deflate"
    };

    final Map<String, dynamic> payload = {
      "mode": "193",
      "username": username,
      "a": DateTime.now().millisecondsSinceEpoch.toString(),
      "producttype": "0",
    };
    print(payload["a"]);
    final response = await http.post(
      Uri.parse(url),
      body: payload,
      headers: headers,
    );

    final status = response.body;
    final doc = XmlDocument.parse(status);
    print(doc);
    final code_1 = doc.findElements("message").toString();
    if (code_1.contains("You've signed out")) {
      return {"message": "You have logged out successfully."};
    } else {
      return {"message": "Log out unsuccessful!!!"};
    }
  }
  // Uncomment this function if you need to add default credentials
  // static void addDefaultCredentials(Box<Map<String, dynamic>> credentialsBox) {
  //   // Add default credentials to the box
  //   credentialsBox.put('credentials', {
  //     "username": "your_default_username",
  //     "password": "your_default_password",
  //     "payload": "your_default_payload",
  //   });
  // }
}
