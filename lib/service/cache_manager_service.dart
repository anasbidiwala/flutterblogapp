import 'package:shared_preferences/shared_preferences.dart';

class CacheService {

  late SharedPreferences preferences;

  CacheService._();

  initSharedPreferences()
  async {
    preferences = await SharedPreferences.getInstance();
  }
  static final instance = CacheService._();

  String? readCache({required String key})
  {
    final cacheData = preferences.getString(key);
    return cacheData;
  }

  writeCache({required String key,required String value})
  {
   preferences.setString(key,value);
  }

  deleteCache({required String key})
  {
    preferences.remove(key);
  }
}