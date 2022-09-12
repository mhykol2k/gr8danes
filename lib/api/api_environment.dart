import 'package:gr8danes/api/api.dart';
import 'package:gr8danes/api/shared_preferences.dart';
import 'package:gr8danes/widget/ftext.dart';

extension ApiEnvironment on API {
  static late Environment _activeEnvironment;

  Environment get activeEnvironment => _activeEnvironment;

  saveEnvironment(Environment e) {
    SharedPreferencesRepository.init();
    SharedPreferencesRepository.putString('environment', e.toString());
    setEnvironment(e);
    httpCall.changeEnvironment(e);
    clearData();
    init();
  }

  setEnvironment(Environment e) async {
    _activeEnvironment = e;
  }
}