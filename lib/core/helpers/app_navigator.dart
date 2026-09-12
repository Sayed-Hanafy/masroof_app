// import 'package:flutter/material.dart';

// class AppNavigator {
//   static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//   static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
//       GlobalKey<ScaffoldMessengerState>();

//   static void showSnackBar(
//     String message, {
//     Color backgroundColor = Colors.red,
//   }) {
//     final messenger = scaffoldMessengerKey.currentState;
//     if (messenger != null) {
//       messenger.showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: backgroundColor,
//         ),
//       );
//       return;
//     }

//     final context = navigatorKey.currentContext;
//     if (context == null) return;

//     final fallbackMessenger = ScaffoldMessenger.maybeOf(context);
//     if (fallbackMessenger != null) {
//       fallbackMessenger.showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: backgroundColor,
//         ),
//       );
//     }
//   }
// }
