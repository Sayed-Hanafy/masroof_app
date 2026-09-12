// import 'package:flutter/material.dart';


// class ThemeController {
//   static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(
//     ThemeMode.dark,
//   );

//   init() {
//     bool result = PreferanceManager().getBool(StorageKey.theme) ?? true;

//     themeNotifier.value = result ? ThemeMode.dark : ThemeMode.light;
//   }

//   static toggleTheme() async {
//     if (themeNotifier.value == ThemeMode.dark) {
//       themeNotifier.value = ThemeMode.light;
//       await PreferanceManager().setBool(StorageKey.theme, false);
//     } else {
//       themeNotifier.value = ThemeMode.dark;
//       await PreferanceManager().setBool(StorageKey.theme, true);
//     }
//   }

//   static bool isDark() => themeNotifier.value == ThemeMode.dark;
// }
