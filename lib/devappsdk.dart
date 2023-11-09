library devappsdk;

import 'package:devappsdk/item_value.dart';
import 'package:shared_preferences_content_provider/shared_preferences_content_provider.dart';

class DevAppManager {
  bool _wastInited = false;
  static const devappProviderAuthority = "com.ksaucedo.devapp";

  static final DevAppManager _singleton = DevAppManager._internal();
  factory DevAppManager() => _singleton;
  DevAppManager._internal();

  Future<void> _init() async {
    try {
      await SharedPreferencesContentProvider.init(
        providerAuthority: devappProviderAuthority,
      );
      _wastInited = true;
    } catch (err) {
      throw Exception('''Proveedor de variables de entorno no encontrado. 
Asegúrate de tener la aplicación correcta instalada e intenta nuevamente.''');
    }
  }

  // readValue puede lanzar exceptions
  Future<String?> readValue(String key) async {
    if (!_wastInited) await _init();
    try {
      final value = await SharedPreferencesContentProvider.get("list_values");
      if (value is! String) return null;
      if (value == "") return null;
      final items = itemValueFromJson(value);
      final index = items.indexWhere((element) => element.name == key);
      if (index == -1) return null;
      final enabled = items[index].state ?? false;
      if (!enabled) return null;
      return items[index].value;
    } catch (err) {
      throw Exception("La lectura de la variable $key fallo");
    }
  }
}
