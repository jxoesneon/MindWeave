import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_service.g.dart';

@riverpod
StorageService storageService(Ref ref) => StorageService();

class StorageService {
  final HiveInterface _hive;
  
  StorageService({HiveInterface? hive}) : _hive = hive ?? Hive;

  Future<Box<T>> openBox<T>(String name) async {
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
