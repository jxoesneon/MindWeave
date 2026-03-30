import 'package:flutter_test/flutter_test.dart';
import 'package:mindweave/core/models/user_preset.dart';
import 'package:mindweave/core/models/user_session.dart';
import 'package:mindweave/core/models/brainwave_preset.dart';

void main() {
  group('Model Serialization Tests', () {
    test('UserPreset should serialize and deserialize correctly', () {
      final now = DateTime.now();
      final preset = UserPreset(
        id: '1',
        userId: 'u1',
        name: 'Focus Deep',
        carrierFrequency: 220.0,
        beatFrequency: 14.0,
        createdAt: now,
      );

      final json = preset.toJson();
      expect(json['name'], 'Focus Deep');
      expect(json['carrier_frequency'], 220.0);
      expect(json['user_id'], 'u1');

      final fromJson = UserPreset.fromJson(json);
      expect(fromJson.name, preset.name);
      expect(fromJson.carrierFrequency, preset.carrierFrequency);
    });

    test('UserSession should serialize and deserialize correctly', () {
      final now = DateTime.now();
      final session = UserSession(
        id: 'session-123',
        userId: 'user-456',
        presetId: 'preset-789',
        startedAt: now,
        durationSeconds: 3600,
      );

      final json = session.toJson();
      expect(json['id'], 'session-123');
      expect(json['duration_seconds'], 3600);
      expect(json['user_id'], 'user-456');

      final fromJson = UserSession.fromJson(json);
      expect(fromJson.id, session.id);
      expect(fromJson.startedAt.toIso8601String(), session.startedAt.toIso8601String());
    });

    test('BrainwavePreset should serialize/deserialize correctly', () {
      const preset = BrainwavePreset(
        id: 'p1',
        name: 'Focus',
        description: 'Concentration boost',
        band: BrainwaveBand.beta,
        beatFrequency: 15.0,
        defaultCarrierFrequency: 200.0,
        iconPath: 'assets/icons/focus.png',
        accentColorValue: 0xFF5D3FD3,
      );
      
      final json = preset.toJson();
      expect(json['name'], 'Focus');
      expect(json['id'], 'p1');
      // No snake_case for BrainwavePreset
      expect(json['beatFrequency'], 15.0);

      final fromJson = BrainwavePreset.fromJson(json);
      expect(fromJson.name, 'Focus');
      expect(fromJson.band, BrainwaveBand.beta);
    });
  });
}
