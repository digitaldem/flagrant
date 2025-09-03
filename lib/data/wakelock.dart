import 'package:wakelock_plus/wakelock_plus.dart';

import '../domain/wakelock.dart';

class WakelockPlusService implements IWakelockPlusService {
  bool _enabled = false;
  WakelockPlusService._(this._enabled);
  static Future<WakelockPlusService> create() async {
    final enabled = await WakelockPlus.enabled;
    return WakelockPlusService._(enabled);
  }

  @override
  bool get enabled => _enabled;

  @override
  Future<void> enable() async {
    await WakelockPlus.enable();
    _enabled = true;
  }

  @override
  Future<void> disable() async {
    await WakelockPlus.disable();
    _enabled = false;
  }
}
