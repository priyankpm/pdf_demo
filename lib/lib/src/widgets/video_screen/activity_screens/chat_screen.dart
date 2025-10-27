import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:whiskers_flutter_app/src/provider.dart';
import 'package:whiskers_flutter_app/src/styles/resources.dart';
import 'package:whiskers_flutter_app/src/styles/utils/app_styles.dart';

import '../../../common_utility/common_utility.dart';
import '../../../models/chat_message_model.dart';
import '../../../viewmodel/video/gif_controller.dart';

final Map<int, String> _defaultImages = {
  0: 'assets/samples/living.jpg',
  1: 'assets/samples/bedroom.jpg',
  2: 'assets/samples/kitchen.jpg',
};

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  DraggableScrollableController? _sheetController;
  ScrollController? _listScrollController;

  late Resources res;
  bool _isExpanded = false;
  Offset _petOffset = const Offset(20, 80);
  int _gifKey = 0;

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    res = ref.read(resourceProvider);
    ref.read(chatViewModelProvider.notifier).init();
    _sheetController = DraggableScrollableController();
    _speech = stt.SpeechToText();
    _chatController.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(videoControllerProvider.notifier).updateCurrentScreen('chat');
      _sheetController?.addListener(_onSheetChanged);
      Future.delayed(const Duration(milliseconds: 500), _scrollToBottom);
    });
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    } else {
      final status = await Permission.microphone.request();

      if (status != PermissionStatus.granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Microphone permission is required'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            if (mounted) {
              setState(() => _isListening = false);
            }
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() => _isListening = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${error.errorMsg}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );

      if (available) {
        setState(() => _isListening = true);

        _speech.listen(
          onResult: (result) {
            setState(() {
              _lastWords = result.recognizedWords;
              _chatController.text = _lastWords;
              _chatController.selection = TextSelection.fromPosition(
                TextPosition(offset: _chatController.text.length),
              );
            });
          },
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 3),
          listenOptions: stt.SpeechListenOptions(
            partialResults: true,
            cancelOnError: true,
            listenMode: stt.ListenMode.deviceDefault,
          ),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Speech recognition not available'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _onSheetChanged() {
    if (!mounted || _sheetController == null) return;

    final size = _sheetController!.size;
    final wasExpanded = _isExpanded;
    final newExpanded = size >= 0.95;

    if (wasExpanded != newExpanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _isExpanded = newExpanded;
            _gifKey++;
          });
        }
      });
    }
  }

  String _getLivingRoomImage() {
    final backgroundState = ref.read(backgroundImageProvider);

    if (backgroundState.isNotEmpty) {
      final livingRoomImagePath = backgroundState[0].path;

      if (!livingRoomImagePath.startsWith('assets/')) {
        final file = File(livingRoomImagePath);
        if (file.existsSync()) {
          return livingRoomImagePath;
        }
      } else {
        return livingRoomImagePath;
      }
    }

    return _defaultImages[0]!;
  }

  String _getPetImage() {
    final videoController = ref.read(videoControllerProvider);
    return videoController.currentGifPath;
  }

  Future<void> _sendMessage() async {
    final message = _chatController.text.trim();
    if (message.isEmpty) return;

    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    }

    _chatController.clear();

    ref.read(chatViewModelProvider.notifier).sendMessage(message, context);

    Future.delayed(const Duration(milliseconds: 400), _scrollToBottom);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || _listScrollController == null) return;
      await Future.delayed(const Duration(milliseconds: 100));
      if (_listScrollController!.hasClients) {
        _listScrollController!.animateTo(
          _listScrollController!.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _sheetController?.removeListener(_onSheetChanged);
    _chatController.dispose();
    _scrollController.dispose();
    _sheetController?.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatViewModelProvider);
    final isTyping = ref.watch(chatViewModelProvider.notifier).isTyping;
    final videoController = ref.watch(videoControllerProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final livingRoomImagePath = _getLivingRoomImage();

    return Scaffold(
      backgroundColor: const Color(0xFFF5E1C0),
      bottomNavigationBar: sendMsgRow(context),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              livingRoomImagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFFF5E1C0),
                  child: const Center(
                    child: Text(
                      "Living Room",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          if (!_isExpanded)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: screenHeight * 0.33,
                margin: EdgeInsets.only(top: screenHeight * 0.08),
                alignment: Alignment.topCenter,
                child: KeyedSubtree(
                  key: ValueKey(
                    'main_gif_${videoController.currentGifPath}_$_gifKey',
                  ),
                  child: Container(
                    height: screenHeight * 0.33,
                    color: Colors.transparent,
                    child: Image.asset(
                      videoController.currentGifPath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/pet/natural.gif",
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

          DraggableScrollableSheet(
            key: const ValueKey('draggable_sheet'),
            controller: _sheetController,
            initialChildSize: 0.5,
            minChildSize: 0.5,
            maxChildSize: 1.0,
            snap: true,
            snapSizes: const [0.5, 1.0],
            builder: (context, scrollController) {
              return _buildChatPanel(
                messages,
                isTyping,
                ref,
                scrollController,
                livingRoomImagePath,
              );
            },
          ),

          if (_isExpanded)
            _buildFloatingPet(
              videoController,
              screenWidth,
              livingRoomImagePath,
            ),
        ],
      ),
    );
  }

  Widget sendMsgRow(BuildContext context) {
    return Container(
      color: Color(0xFFF6F6F6),
      child: IntrinsicHeight(
        child: Column(
          children: [
            Divider(color: Color(0XFFD1D1D6), height: 0),
            Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 12 : 24,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _chatController,
                      decoration: InputDecoration(
                        hintText: _isListening
                            ? 'Listening...'
                            : 'Type a message...',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: Color(0XFFD1D1D6)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: Color(0XFFD1D1D6)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: Color(0XFFD1D1D6)),
                        ),
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        prefixIcon: _isListening
                            ? Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Icon(
                                  Icons.mic,
                                  color: res.themes.darkOrange,
                                  size: 24,
                                ),
                              )
                            : null,
                      ),
                      enabled: !_isListening,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isListening
                          ? res.themes.darkOrange.withValues(alpha: 0.1)
                          : Colors.transparent,
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isListening ? Icons.stop : Icons.mic_none,
                        color: _isListening
                            ? res.themes.darkOrange
                            : Color(0XFF7A7A7A),
                        size: 28,
                      ),
                      onPressed: _toggleListening,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Color(0XFF7A7A7A), size: 28),
                    onPressed: _chatController.text.trim().isNotEmpty
                        ? _sendMessage
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingPet(
    VideoControllerState videoController,
    double screenWidth,
    String livingRoomImagePath,
  ) {
    return Positioned(
      left: _petOffset.dx,
      top: _petOffset.dy,
      child: GestureDetector(
        onTap: () {
          _sheetController?.animateTo(
            0.4,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        onPanUpdate: (details) {
          setState(() => _petOffset += details.delta);
        },
        onPanEnd: (details) {
          final screenSize = MediaQuery.of(context).size;
          const petWidth = 160.0, petHeight = 90.0;

          final dx = _petOffset.dx < screenSize.width / 2
              ? 20.0
              : screenSize.width - petWidth - 20.0;
          final dy = _petOffset.dy.clamp(
            80.0,
            screenSize.height - petHeight - 80.0,
          );

          if (!mounted) return;
          setState(() => _petOffset = Offset(dx, dy));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Image.asset(
                  livingRoomImagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF5E1C0),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    );
                  },
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: KeyedSubtree(
                  key: ValueKey(
                    'floating_gif_${videoController.currentGifPath}_$_gifKey',
                  ),
                  child: Image.asset(
                    videoController.currentGifPath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/pet/natural.gif",
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatPanel(
    List<ChatMessageModel> messages,
    bool isTyping,
    WidgetRef ref,
    ScrollController sc,
    String livingRoomImagePath,
  ) {
    _listScrollController = sc;

    if (isTyping) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(_isExpanded ? 0 : 18),
          topRight: Radius.circular(_isExpanded ? 0 : 18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(chatScreenBg),
                  fit: BoxFit.cover,
                ),
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: ListView.builder(
                controller: sc,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: messages.length + (isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (isTyping && index == messages.length) {
                    return _buildTypingIndicator(livingRoomImagePath);
                  }

                  final msg = messages[index];
                  final prev = index > 0 ? messages[index - 1] : null;
                  final showDate =
                      prev == null ||
                      !_isSameDay(prev.timestamp, msg.timestamp);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showDate)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _formatDate(msg.timestamp),
                                style: AppTextStyle().commonTextStyle(
                                  textColor: Colors.black,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: msg.isUser
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!msg.isUser) ...[
                              _buildAvatar(
                                _getPetImage(),
                                isPet: true,
                                livingRoomImagePath: livingRoomImagePath,
                              ),
                              const SizedBox(width: 8),
                            ],
                            Flexible(
                              child: Column(
                                crossAxisAlignment: msg.isUser
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      right: msg.isUser ? 0 : 80,
                                      left: msg.isUser ? 80 : 0,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: msg.isUser
                                          ? res.themes.grey100.withValues(
                                              alpha: 0.5,
                                            )
                                          : res.themes.darkOrange.withValues(
                                              alpha: 0.1,
                                            ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      msg.text,
                                      style: AppTextStyle().commonTextStyle(
                                        textColor: res.themes.blackPure,
                                        appFontStyle: AppFontStyle.regular,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (msg.isUser) ...[
                              const SizedBox(width: 8),
                              _buildAvatar(
                                profilePic,
                                isPet: false,
                                livingRoomImagePath: livingRoomImagePath,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(String livingRoomImagePath) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(
            _getPetImage(),
            isPet: true,
            livingRoomImagePath: livingRoomImagePath,
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: res.themes.darkOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
                const SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        final delay = index * 0.2;
        final animValue = (value - delay).clamp(0.0, 1.0);
        final opacity = (animValue * 2).clamp(0.3, 1.0);

        return Opacity(
          opacity: opacity,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: res.themes.darkOrange,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
      onEnd: () {
        if (mounted) setState(() {});
      },
    );
  }

  Widget _buildAvatar(
    String imagePath, {
    required bool isPet,
    required String livingRoomImagePath,
  }) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: Stack(
        children: [
          if (isPet)
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Image.asset(
                livingRoomImagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: res.themes.darkOrange.withValues(alpha: 0.1),
                    ),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(2),
            child: ClipOval(
              child: imagePath.endsWith('.gif')
                  ? Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/pet/natural.gif',
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : imagePath.startsWith('assets/')
                  ? Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          isPet ? Icons.pets : Icons.person,
                          size: 20,
                          color: Colors.grey,
                        );
                      },
                    )
                  : Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          isPet ? Icons.pets : Icons.person,
                          size: 20,
                          color: Colors.grey,
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDay = DateTime(dt.year, dt.month, dt.day);

    if (messageDay == today) return 'Today';
    if (messageDay == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    }
    return "${dt.day}/${dt.month}/${dt.year}";
  }
}
