import 'package:flutter/material.dart';
import '../services/tts_service.dart';
import 'topics_list_screen.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  String _statusMessage = 'Đang khởi tạo âm thanh...';
  bool _showOnlineModeNotice = false;

  @override
  void initState() {
    super.initState();
    _checkSystem();
  }

  Future<void> _checkSystem() async {
    final ttsState = await TtsService().initialize();

    if (!mounted) return;

    if (ttsState == TtsState.readyOffline) {
      // Offline OK -> Vào luôn
      _goToMain();
    } else {
      // Offline Fail -> Báo dùng Online
      setState(() {
        _showOnlineModeNotice = true;
        _statusMessage =
            'Máy không hỗ trợ phát âm Offline.\nApp sẽ sử dụng chế độ Online.';
      });

      // Tự động vào sau 2s
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) _goToMain();
      });
    }
  }

  void _goToMain() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const TopicsListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_showOnlineModeNotice) ...[
                const Icon(
                  Icons.wifi_tethering,
                  color: Color(0xFF00d9ff),
                  size: 64,
                ),
                const SizedBox(height: 24),
                Text(
                  _statusMessage,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Vui lòng kết nối mạng để nghe phát âm.',
                  style: TextStyle(color: Colors.white70),
                ),
              ] else ...[
                const CircularProgressIndicator(color: Color(0xFF00d9ff)),
                const SizedBox(height: 20),
                Text(
                  _statusMessage,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
