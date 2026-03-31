import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_service.g.dart';

@riverpod
StorageService storageService(Ref ref) => StorageService();

class StorageService {
  final HiveInterface _hive;

  StorageService({HiveInterface? hive}) : _hive = hive ?? Hive;

  Future<Box<T>> openBox<T>(String name) async {
    // If box is already open with wrong type, close it first
    if (_hive.isBoxOpen(name)) {
      try {
        return _hive.box<T>(name);
      } catch (e) {
        // Type mismatch - close and reopen
        await _hive.box(name).close();
      }
    }
    return await _hive.openBox<T>(name);
  }

  Future<T?> get<T>(String boxName, String key, {T? defaultValue}) async {
    final box = await openBox(boxName);
    return box.get(key, defaultValue: defaultValue) as T?;
  }

  Future<void> put<T>(String boxName, String key, T value) async {
    final box = await openBox(boxName);
    await box.put(key, value);
  }
}
