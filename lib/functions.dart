// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:wifi/model/user/user_model.dart';

// void addDefaultCredentials(Box<UserModel>? box) {
//   // You can customize this with your default usernames and passwords
//   Map<String, Map<String, dynamic>> userData = {
//     "21AGRBTC007": {
//       "date": "2023-12-25",
//       "data_usage": 0,

//       "password": "940Fa51*@*"
//     },
//     "22AGBTC013": {
//       "date": "2023-12-25",
//       "data_usage": 0,
//       "password": "Computer@123"
//     },
//     "22AGRBTC029": {
//       "date": "2023-12-25",
//       "data_usage": 0,
//       "password": "940Fa51*@*"
//     },
//     "22AGRBTC044": {
//       "date": "2023-12-25",
//       "data_usage": 0,
//       "password": "940Fa51***"
//     },
//     "22AGRBTC054": {
//       "date": "2023-12-25",
//       "data_usage": 0,
//       "password": "Advanced@123"
//     },
//     "22CSEBTC072": {
//       "date": "2023-12-25",
//       "data_usage": 0,
//       "password": "940Fa51***"
//     }
//   };

//   // Add default credentials to the box
//   for (final entry in userData.entries) {
//     final username = entry.key;
//     final credentials = entry.value;
//     box?.put(username, credentials  );
//   }
// }

import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

String encodeFormData(Map<String, String> data) {
  return data.entries.map((entry) {
    final key = Uri.encodeComponent(entry.key);
    final value = Uri.encodeComponent(entry.value);
    return '$key=$value';
  }).join('&');
}

// get toast messages
void showToast(String message, BuildContext context) {
  toastification.show(
    context: context,
    type: ToastificationType.success,
    style: ToastificationStyle.fillColored,
    autoCloseDuration: const Duration(seconds: 3),
    title: message,
    description: "A new account has been added",
    alignment: Alignment.bottomCenter,
    direction: TextDirection.ltr,
    animationDuration: const Duration(milliseconds: 300),
    animationBuilder: (context, animation, alignment, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    icon: const Icon(Icons.check),
    primaryColor: const Color.fromARGB(255, 22, 144, 26),
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [
      BoxShadow(
        color: Color(0x07000000),
        blurRadius: 16,
        offset: Offset(0, 16),
        spreadRadius: 0,
      )
    ],
    showProgressBar: true,
    closeButtonShowType: CloseButtonShowType.onHover,
    closeOnClick: false,
    pauseOnHover: true,
    dragToClose: true,
    callbacks: ToastificationCallbacks(
      onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
      onCloseButtonTap: (toastItem) =>
          print('Toast ${toastItem.id} close button tapped'),
      onAutoCompleteCompleted: (toastItem) =>
          print('Toast ${toastItem.id} auto complete completed'),
      onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
    ),
  );
}
