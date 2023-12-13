library devappsdk;

import 'dart:io';

import 'package:devappsdk/item_value.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences_content_provider/shared_preferences_content_provider.dart';

abstract class ProviderReader {
  Future<void> init();
  Future<List<ItemValue>> getValues();
}

class _MovilePrivider implements ProviderReader {
  static const devappProviderAuthority = "com.ksaucedo.devapp";
  @override
  Future<List<ItemValue>> getValues() async {
    final value = await SharedPreferencesContentProvider.get("list_values");
    if (value is! String) return [];
    if (value == "") return [];
    final items = itemValueFromJson(value);
    return items;
  }

  @override
  Future<void> init() async {
    await SharedPreferencesContentProvider.init(
      providerAuthority: devappProviderAuthority,
    );
  }
}

class _LocalHttpPrivider implements ProviderReader {
  @override
  Future<List<ItemValue>> getValues() async {
    final response = await http.get(Uri.parse("http://localhost:9696"));
    if (response.statusCode != 200) {
      throw "El servidor de variables no esta disponible";
    }
    return itemValueFromJson(response.body);
  }

  @override
  Future<void> init() async {}
}

class DevAppManager {
  bool _wastInited = false;

  static final DevAppManager _singleton = DevAppManager._internal();
  factory DevAppManager() => _singleton;
  late ProviderReader reader;
  DevAppManager._internal();

  Future<void> _init() async {
    if (_wastInited) return;
    reader = Platform.isAndroid ? _MovilePrivider() : _LocalHttpPrivider();
    try {
      await reader.init();
      await Future.delayed(const Duration(seconds: 1));
      _wastInited = true;
    } catch (err) {
      if (kDebugMode) print("DevAppManager _init Error: ${err.toString()}");
      throw Exception('''Proveedor de variables de entorno no encontrado.''');
    }
  }

  Future<List<ItemValue>> readAll() async {
    await _init();
    try {
      final items = await reader.getValues();
      return items;
    } catch (err) {
      throw Exception("La lectura de las variables fallo");
    }
  }

  // readValue puede lanzar exceptions
  Future<String?> readValue(String key) async {
    await _init();
    try {
      final items = await reader.getValues();
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
