import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';

late GetStorage getStorage;

initGetStorage() async {
  final path = await getApplicationSupportDirectory();
  getStorage = GetStorage('GetStorage', path.path);
  await getStorage.initStorage;
}
