import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindweave/core/storage/storage_service.dart';
import '../mocks.dart';

void main() {
  late StorageService storageService;
  late FakeHive fakeHive;
  late MockBox<String> mockBox;

  setUp(() {
    fakeHive = FakeHive();
    mockBox = MockBox<String>();
    storageService = StorageService(hive: fakeHive);

    fakeHive.setBox('testBox', mockBox);
  });

  group('StorageService Tests', () {
    test('openBox calls hive.openBox', () async {
      final result = await storageService.openBox<String>('testBox');
      
      expect(result, mockBox);
    });

    test('get retrieves value from box', () async {
      when(() => mockBox.get('key1', defaultValue: any(named: 'defaultValue')))
          .thenReturn('value1');

      final result = await storageService.get<String>('testBox', 'key1');

      expect(result, 'value1');
      verify(() => mockBox.get('key1', defaultValue: null)).called(1);
    });

    test('get returns default value when key missing', () async {
      when(() => mockBox.get('key2', defaultValue: 'default'))
          .thenReturn('default');

      final result = await storageService.get<String>(
        'testBox', 
        'key2', 
        defaultValue: 'default'
      );

      expect(result, 'default');
    });

    test('put saves value to box', () async {
      when(() => mockBox.put(any(), any())).thenAnswer((_) async => {});

      await storageService.put<String>('testBox', 'key1', 'value1');

      verify(() => mockBox.put('key1', 'value1')).called(1);
    });
  });
}
