import '../Interfaces/Local_Storage.Interface.dart';
import '../services/Local_storage.Service.dart';

class ConfigController {
  static final ConfigController instance = ConfigController._();
  final ILocalStorage storage = LocalStorageService();

  Future<String> getUrlBase() async {
    return 'http://localhost:8080/v1';
  }

  ConfigController._();
}
