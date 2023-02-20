import 'package:shared_preferences/shared_preferences.dart';

class appConfig {
  // Obtain shared preferences.
  static late final prefs;
  static bool _init = false;

  static Future init() async {
    if (_init) return;
    prefs = await SharedPreferences.getInstance();
    _init = true;
    return prefs;
  }

  static String getChEndPoint() {
    return prefs.getString("chEndPoint") ??
        String.fromEnvironment('chEndPoint',
            defaultValue:
                'https://content-api.sitecorecloud.io/api/content/v1/preview/graphql');
    ;
  }

  static void setChEndPoint(String? endPoint) {
    prefs.setString("chEndPoint", endPoint);
  }

  static String getAppRootID() {
    return prefs.getString("chAppRootID") ??
        String.fromEnvironment('chAppRootID',
            defaultValue: 'Libej7UF9EW9UJUnY5FoNg');
  }

  static void setAppRootID(String? id) {
    prefs.setString("chAppRootID", id);
  }

  static String getToken() {
    return prefs.getString("chToken") ??
        String.fromEnvironment('chToken',
            defaultValue:
                'SmNmakFPVXlzUzAxRzkrR0E2bjBjQ3ZJL3d3Sk5OUTdkNlFsRGtCSUxpZz18aGMtc2FsZXMtMTItZWEtZjEwOTQ=');
  }

  static void setToken(String? token) {
    prefs.setString("chToken", token);
  }
}
