import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'settings_controller.dart';

class SettingsPage extends StatelessWidget {
  final SettingsController _settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('theme'.tr),
            trailing: Obx(
              () => DropdownButton(
                padding: EdgeInsets.only(left: 12, right: 12),
                value: _settingsController.themeModeOption.value,
                focusColor: Colors.transparent,
                // 设置焦点颜色为透明
                items: [
                  DropdownMenuItem(
                    value: ThemeModeOption.light,
                    child: Text('light'.tr),
                  ),
                  DropdownMenuItem(
                    value: ThemeModeOption.dark,
                    child: Text('dark'.tr),
                  ),
                  DropdownMenuItem(
                    value: ThemeModeOption.system,
                    child: Text('follow_system'.tr),
                  ),
                ],
                onChanged: (value) =>
                    _settingsController.setThemeMode(value as ThemeModeOption),
              ),
            ),
          ),
          ListTile(
            title: Text('language'.tr),
            trailing: DropdownButton(
              padding: EdgeInsets.only(left: 12, right: 12),
              value: _settingsController.selectedLanguage.value,
              focusColor: Colors.transparent,
              // 设置焦点颜色为透明
              items: [
                DropdownMenuItem(
                  value: 'system',
                  child: Text('follow_system'.tr),
                ),
                DropdownMenuItem(
                  value: 'en_US',
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: 'zh_CN',
                  child: Text('中文'),
                ),
              ],
              onChanged: (value) => _settingsController.changeLanguage(value!),
            ),
          ),
        ],
      ),
    );
  }
}
