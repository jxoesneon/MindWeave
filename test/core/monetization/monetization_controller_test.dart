import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindweave/core/monetization/monetization_controller.dart';
import 'package:mindweave/core/storage/storage_service.dart';
import 'dart:async';

class FakeStorageService extends Fake implements StorageService {
  final Map<String, dynamic> data = {};

  @override
  Future<T?> get<T>(String boxName, String key, {T? defaultValue}) async {
    return (data['$boxName:$key'] as T?) ?? defaultValue;
  }

  @override
  Future<void> put<T>(String boxName, String key, T value) async {
    data['$boxName:$key'] = value;
  }
}

void main() {
  late FakeStorageService fakeStorage;

  setUp(() {
    fakeStorage = FakeStorageService();
  });

  group('MonetizationController Tests', () {
    test('state becomes true if sessions >= 5 in storage on init', () async {
      fakeStorage.data['stats:sessionCount'] = 5;

      final container = ProviderContainer(
        overrides: [
          storageServiceProvider.overrideWithValue(fakeStorage),
        ],
      );
      
      final completer = Completer<void>();
      container.listen(
        monetizationControllerProvider,
        (previous, next) {
          if (next == true) completer.complete();
        },
        fireImmediately: true,
      );
      
      // If state is already true, it will complete in fireImmediately.
      // Otherwise, we wait for the async _init to trigger the listener.
      try {
        await completer.future.timeout(const Duration(seconds: 1));
      } catch (_) {
        // Handle timeout
      }
      
      final state = container.read(monetizationControllerProvider);
      expect(state, true);
      container.dispose();
    });

    test('recordSession increments counts and updates state', () async {
      final container = ProviderContainer(
        overrides: [
          storageServiceProvider.overrideWithValue(fakeStorage),
        ],
      );
      
      final notifier = container.read(monetizationControllerProvider.notifier);
      await notifier.recordSession(60); 
      
      expect(fakeStorage.data['stats:sessionCount'], 1);
      expect(fakeStorage.data['stats:totalMinutes'], 1);
      container.dispose();
    });
  });
}
