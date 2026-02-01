import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState {
  initializing,
  readyOffline, // Native engine OK
  readyOnline, // Native fail, dùng Online API
  notSupported, // Cả 2 đều fail (hiếm)
}

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  FlutterTts? _flutterTts;
  AudioPlayer? _audioPlayer;

  TtsState _state = TtsState.initializing;
  TtsState get state => _state;

  bool get isReady =>
      _state == TtsState.readyOffline || _state == TtsState.readyOnline;

  /// Initialize
  Future<TtsState> initialize() async {
    _state = TtsState.initializing;
    debugPrint("TTS: Starting initialization...");

    try {
      // 1. Setup Online Player trước (backup)
      _audioPlayer = AudioPlayer();

      // 2. Setup Offline TTS
      _flutterTts = FlutterTts();
      if (Platform.isAndroid) {
        await _initializeAndroid();
      } else if (Platform.isIOS) {
        await _initializeIOS();
      }

      // 3. Kiểm tra support Offline
      bool isKoreanOfflineAvailable = await _checkKoreanSupport();

      if (isKoreanOfflineAvailable) {
        _state = TtsState.readyOffline;
        debugPrint("TTS: Using OFFLINE mode (Native Engine).");
      } else {
        _state = TtsState.readyOnline;
        debugPrint(
          "TTS: Native Engine failed. Using ONLINE mode (Google API).",
        );
      }
    } catch (e) {
      debugPrint("TTS: Initialization failed - $e");
      // Fallback to online anyway
      _state = TtsState.readyOnline;
    }

    return _state;
  }

  Future<void> _initializeAndroid() async {
    await _flutterTts!.awaitSpeakCompletion(true);
    // Config params
    await _flutterTts!.setSpeechRate(0.5);
    await _flutterTts!.setVolume(1.0);
    await _flutterTts!.setPitch(1.0);
  }

  Future<void> _initializeIOS() async {
    await _flutterTts!.setSharedInstance(true);
    await _flutterTts!
        .setIosAudioCategory(IosTextToSpeechAudioCategory.playback, [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
        ], IosTextToSpeechAudioMode.voicePrompt);
  }

  Future<bool> _checkKoreanSupport() async {
    // Chỉ check trên engine hiện tại, ko cố switch engine nữa để tránh lỗi
    try {
      var available = await _flutterTts!.isLanguageAvailable('ko-KR');
      return available == 1;
    } catch (_) {
      return false;
    }
  }

  Future<void> speak(String text) async {
    if (text.isEmpty) return;

    try {
      if (_state == TtsState.readyOffline) {
        // Offline Mode
        await _flutterTts!.setVolume(1.0);
        await _flutterTts!.speak(text);
      } else {
        // Online Mode
        await _playOnline(text);
      }
    } catch (e) {
      debugPrint("TTS Speak Error: $e");
      // Fallback online if offline fails mid-session
      if (_state == TtsState.readyOffline) {
        debugPrint("TTS: Fallback to online...");
        await _playOnline(text);
      }
    }
  }

  Future<void> _playOnline(String text) async {
    try {
      // Stop previous
      await _audioPlayer?.stop();

      // Google Translate TTS API
      final url = Uri.encodeFull(
        "https://translate.google.com/translate_tts?ie=UTF-8&q=$text&tl=ko&client=tw-ob",
      );

      await _audioPlayer?.play(UrlSource(url));
      debugPrint("TTS: Played online audio for '$text'");
    } catch (e) {
      debugPrint("TTS: Online play error: $e");
    }
  }

  void stop() {
    _flutterTts?.stop();
    _audioPlayer?.stop();
  }
}
