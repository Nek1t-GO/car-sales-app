import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/vin_model.dart';

class VinService {
  static const _key = 'vin_list';

  // Загружает список VIN с учётом всех полей модели (включая bodyType и configuration)
  static Future<List<VinData>> loadVins() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((item) => VinData.fromJson(item)).toList();
  }

  // Сохраняет список VIN с учётом всех полей модели (включая bodyType и configuration)
  static Future<void> saveVins(List<VinData> vins) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(vins.map((v) => v.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  static Future<void> addVin(VinData vin) async {
    final vins = await loadVins();
    vins.add(vin);
    await saveVins(vins);
  }

  static Future<void> deleteVin(String vinCode) async {
    final vins = await loadVins();
    vins.removeWhere((v) => v.vin == vinCode);
    await saveVins(vins);
  }
}
