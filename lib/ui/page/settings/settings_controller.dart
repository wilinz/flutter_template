import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kt_dart/kt.dart';

import '../../color_schemes.g.dart';

enum ThemeModeOption { light, dark, system }

extension LocaleExtensions on Locale {
  String toLocaleString() {
    String languageCode = this.languageCode;
    String countryCode = this.countryCode ?? "";
    return "${languageCode}_$countryCode";
  }
}

class SettingsController extends GetxController {
  final _storage = GetStorage();
  final _themeKey = 'theme';
  final _languageKey = 'language';

  var themeModeOption = ThemeModeOption.system.obs;
  var selectedLanguage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // 从存储中加载主题设置和语言设置
    final savedThemeMode = _storage.read(_themeKey);
    themeModeOption.value = savedThemeMode != null
        ? ThemeModeOption.values[savedThemeMode]
        : ThemeModeOption.system;

    selectedLanguage.value =
        _storage.read(_languageKey) ?? (Get.deviceLocale?.toLocaleString() ?? '');
  }

  void setThemeMode(ThemeModeOption option) {
    themeModeOption.value = option;
    // 将主题设置保存到存储中
    var isDarkMode = false;
    if (option == ThemeModeOption.dark) {
      isDarkMode = true;
    } else if (option == ThemeModeOption.system) {
      isDarkMode = Get.isPlatformDarkMode;
    }
    if (isDarkMode) {
      Get.changeTheme(
          ThemeData(useMaterial3: true, colorScheme: darkColorScheme));
    } else {
      Get.changeTheme(
          ThemeData(useMaterial3: true, colorScheme: lightColorScheme));
    }
    _storage.write(_themeKey, option.index);
  }

  void changeLanguage(String language) {
    selectedLanguage.value = language;
    if (language == 'system') {
      Get.deviceLocale?.let((it) {
        Get.updateLocale(it);
      });
    } else {
      final locale = language.split("_");
      if (locale.length == 2) {
        Get.updateLocale(Locale(locale[0], locale[1]));
      }
    }
    // 将语言设置保存到存储中
    _storage.write(_languageKey, selectedLanguage.value);
  }
}
