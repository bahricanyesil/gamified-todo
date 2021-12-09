/// Abstract local manager interface, implemented for Hive.
abstract class ILocalManager {
  /// Initialize the local storage.
  Future<void> initLocalStorage();

  /// Clears all data in the local storage.
  Future<void> clearAll();
}
