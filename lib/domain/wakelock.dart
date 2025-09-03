abstract class IWakelockPlusService {
  bool get enabled;
  Future<void> enable();
  Future<void> disable();
}
