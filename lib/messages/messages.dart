import 'package:flutter_template/messages/en_US.dart';
import 'package:flutter_template/messages/zh_CN.dart';
import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en_US, //
        'zh_CN': zh_CN
      };
}
