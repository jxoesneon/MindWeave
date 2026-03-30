# Audio Engine: SoLoud Bridge

MindWeave uses a high-performance C++ audio engine via Flutter FFI.

## 🧱 Component Stack
1.  **Dart Layer**: `AudioController` (Riverpod) and `AudioService`.
2.  **FFI Bridge**: Bindings to the SoLoud library.
3.  **C++ Layer**: `SineWaveGenerator` and `AudioMixer`.

## 🧮 Frequency Logic
Binaural beats require a specific offset between the left and right channels, centered around a carrier frequency.

```dart
// Logic from technical_specifications.md
static (double, double) calculateFrequencies({
  required double beatFrequency,
  required double carrierFrequency,
}) {
  final halfBeat = beatFrequency / 2;
  final leftFreq = carrierFrequency - halfBeat;
  final rightFreq = carrierFrequency + halfBeat;
  return (leftFreq, rightFreq);
}
```

## 🔉 Dependencies
- **flutter_soloud**: Low-latency, C++ backend.
- **path_provider**: Local file access for assets.

## 🛠️ Planned Features
- Gapless looping.
- Fade in/out.
- Isochronic tones (alternative to binaural).
- FFT-based visualizers.
