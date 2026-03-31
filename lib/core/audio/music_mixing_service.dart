import 'dart:async';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logging/logging.dart';

/// Service for mixing user's music library with binaural beats.
///
/// Uses on_audio_query to access local music files and SoLoud to
/// mix them with the binaural beat audio.
class MusicMixingService {
  static final MusicMixingService _instance = MusicMixingService._internal();
  factory MusicMixingService() => _instance;
  MusicMixingService._internal();

  final OnAudioQuery _audioQuery = OnAudioQuery();
  final SoLoud _soloud = SoLoud.instance;
  final Logger _logger = Logger('MusicMixingService');

  bool _isInitialized = false;
  AudioSource? _currentMusicSource;
  SoundHandle? _musicHandle;
  double _musicVolume = 0.3; // Default music volume (30%)
  double _binauralVolume = 0.7; // Default binaural volume (70%)

  // Stream controllers
  final StreamController<List<SongModel>> _songsController =
      StreamController<List<SongModel>>.broadcast();
  final StreamController<bool> _isPlayingController =
      StreamController<bool>.broadcast();

  Stream<List<SongModel>> get songsStream => _songsController.stream;
  Stream<bool> get isPlayingStream => _isPlayingController.stream;

  double get musicVolume => _musicVolume;
  double get binauralVolume => _binauralVolume;
  bool get isPlayingMusic => _currentMusicSource != null;

  /// Initialize the music mixing service.
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Request storage permission for accessing music
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        _logger.warning('Storage permission not granted');
        return;
      }

      _isInitialized = true;
      _logger.info('MusicMixingService initialized');
    } catch (e) {
      _logger.severe('Failed to initialize music service: $e');
    }
  }

  /// Load songs from the device's music library.
  Future<List<SongModel>> loadMusicLibrary() async {
    try {
      final songs = await _audioQuery.querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      _songsController.add(songs);
      _logger.info('Loaded ${songs.length} songs from library');
      return songs;
    } catch (e) {
      _logger.severe('Failed to load music library: $e');
      return [];
    }
  }

  /// Search songs by title, artist, or album.
  Future<List<SongModel>> searchSongs(String query) async {
    try {
      final allSongs = await loadMusicLibrary();
      final lowerQuery = query.toLowerCase();

      return allSongs.where((song) {
        final title = song.title.toLowerCase();
        final artist = (song.artist ?? '').toLowerCase();
        final album = (song.album ?? '').toLowerCase();

        return title.contains(lowerQuery) ||
            artist.contains(lowerQuery) ||
            album.contains(lowerQuery);
      }).toList();
    } catch (e) {
      _logger.severe('Failed to search songs: $e');
      return [];
    }
  }

  /// Play a song from the music library.
  Future<bool> playSong(SongModel song) async {
    try {
      // Stop current music if playing
      await stopMusic();

      final filePath = song.data;
      _logger.info('Playing song: ${song.title} from $filePath');

      // Load and play the audio file using SoLoud
      _currentMusicSource = await _soloud.loadFile(filePath);
      _musicHandle = await _soloud.play(
        _currentMusicSource!,
        volume: _musicVolume,
        looping: true,
        pan: 0.0, // Center pan
      );

      _isPlayingController.add(true);
      _logger.info('Started playing: ${song.title}');
      return true;
    } catch (e) {
      _logger.severe('Failed to play song: $e');
      return false;
    }
  }

  /// Stop the currently playing music.
  Future<void> stopMusic() async {
    try {
      if (_musicHandle != null) {
        await _soloud.stop(_musicHandle!);
        _musicHandle = null;
      }

      if (_currentMusicSource != null) {
        await _soloud.disposeSource(_currentMusicSource!);
        _currentMusicSource = null;
      }

      _isPlayingController.add(false);
      _logger.info('Music stopped');
    } catch (e) {
      _logger.warning('Error stopping music: $e');
    }
  }

  /// Pause the currently playing music.
  Future<void> pauseMusic() async {
    try {
      if (_musicHandle != null) {
        _soloud.setPause(_musicHandle!, true);
        _isPlayingController.add(false);
      }
    } catch (e) {
      _logger.warning('Error pausing music: $e');
    }
  }

  /// Resume paused music.
  Future<void> resumeMusic() async {
    try {
      if (_musicHandle != null) {
        _soloud.setPause(_musicHandle!, false);
        _isPlayingController.add(true);
      }
    } catch (e) {
      _logger.warning('Error resuming music: $e');
    }
  }

  /// Set the music volume (0.0 to 1.0).
  Future<void> setMusicVolume(double volume) async {
    _musicVolume = volume.clamp(0.0, 1.0);

    try {
      if (_musicHandle != null) {
        _soloud.setVolume(_musicHandle!, _musicVolume);
      }
    } catch (e) {
      _logger.warning('Error setting music volume: $e');
    }
  }

  /// Set the binaural beats volume (0.0 to 1.0).
  /// This adjusts the binaural audio relative to music.
  Future<void> setBinauralVolume(double volume) async {
    _binauralVolume = volume.clamp(0.0, 1.0);
    // The actual binaural volume is controlled by AudioService
    // This is just for tracking the mix ratio
  }

  /// Set the mix balance between music and binaural beats.
  /// value: -1.0 (full binaural) to 1.0 (full music), 0.0 = equal mix
  Future<void> setMixBalance(double balance) async {
    // balance: -1.0 to 1.0
    // -1.0 = 100% binaural, 0% music
    // 0.0 = 50% binaural, 50% music
    // 1.0 = 0% binaural, 100% music

    final clampedBalance = balance.clamp(-1.0, 1.0);

    if (clampedBalance < 0) {
      // More binaural, less music
      _binauralVolume = 1.0;
      _musicVolume = 1.0 + clampedBalance; // 0.0 to 1.0
    } else {
      // More music, less binaural
      _binauralVolume = 1.0 - clampedBalance; // 1.0 to 0.0
      _musicVolume = 1.0;
    }

    await setMusicVolume(_musicVolume);
    // Binaural volume is applied via AudioService
  }

  /// Fade music volume over time.
  Future<void> fadeMusicVolume(
    double targetVolume, {
    Duration duration = const Duration(seconds: 2),
  }) async {
    final steps = 20;
    final stepDuration = Duration(
      milliseconds: duration.inMilliseconds ~/ steps,
    );
    final startVolume = _musicVolume;
    final volumeDiff = targetVolume - startVolume;

    for (var i = 0; i <= steps; i++) {
      final progress = i / steps;
      final newVolume = startVolume + (volumeDiff * progress);
      await setMusicVolume(newVolume);
      await Future.delayed(stepDuration);
    }
  }

  /// Get albums from the music library.
  Future<List<AlbumModel>> getAlbums() async {
    try {
      return await _audioQuery.queryAlbums();
    } catch (e) {
      _logger.severe('Failed to get albums: $e');
      return [];
    }
  }

  /// Get artists from the music library.
  Future<List<ArtistModel>> getArtists() async {
    try {
      return await _audioQuery.queryArtists();
    } catch (e) {
      _logger.severe('Failed to get artists: $e');
      return [];
    }
  }

  /// Get playlists from the music library.
  Future<List<PlaylistModel>> getPlaylists() async {
    try {
      return await _audioQuery.queryPlaylists();
    } catch (e) {
      _logger.severe('Failed to get playlists: $e');
      return [];
    }
  }

  /// Get songs from a specific album.
  Future<List<SongModel>> getSongsFromAlbum(int albumId) async {
    try {
      final songs = await _audioQuery.queryAudiosFrom(
        AudiosFromType.ALBUM_ID,
        albumId,
      );
      return songs;
    } catch (e) {
      _logger.severe('Failed to get songs from album: $e');
      return [];
    }
  }

  /// Dispose resources.
  Future<void> dispose() async {
    await stopMusic();
    _songsController.close();
    _isPlayingController.close();
  }
}
