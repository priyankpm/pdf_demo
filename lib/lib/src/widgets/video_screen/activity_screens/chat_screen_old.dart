import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';
import 'package:whiskers_flutter_app/src/enum/chat_message_type.dart';
import 'package:whiskers_flutter_app/src/models/memory_frame_model.dart';
import 'package:whiskers_flutter_app/src/provider.dart';
import 'package:whiskers_flutter_app/src/styles/resources.dart';

import '../../../common_utility/common_utility.dart';
import '../../../common_utility/image_utils.dart';
import '../../../enum/memory_frame_type.dart';
import '../../../models/chat_message_model.dart';
import '../../../viewmodel/video/gif_controller.dart';
import '../../common_widgets/gradient_widget.dart';
import 'memory_wall_screen.dart';

class ChatViewModel extends StateNotifier<List<ChatMessageModel>> {
  ChatViewModel() : super([]);

  void init() {
    state = [];
  }

  void addMessage(ChatMessageModel message) {
    state = [...state, message];
  }

  void clearMessages() {
    state = [];
  }
}

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final PanelController _panelController = PanelController();
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late Resources res;
  bool _isExpanded = false;
  bool _isHalfOpen = false;
  Offset _petOffset = const Offset(20, 80);
  double _panelHeight = 0.0;
  int _gifKey = 0;

  // Default images for fallback
  final Map<int, String> _defaultImages = {
    0: 'assets/samples/living.jpg',
    1: 'assets/samples/bedroom.jpg',
    2: 'assets/samples/kitchen.jpg',
  };

  @override
  void initState() {
    super.initState();
    res = ref.read(resourceProvider);
    ref.read(chatViewModelProvider.notifier).init();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(videoControllerProvider.notifier).updateCurrentScreen('chat');
    });
  }

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Get living room background image - index 0
  String _getLivingRoomImage() {
    final backgroundState = ref.read(backgroundImageProvider);

    if (backgroundState.isNotEmpty &&
        backgroundState.length > 0 &&
        backgroundState[0] != null) {
      final livingRoomImage = backgroundState[0]!;
      final livingRoomImagePath = livingRoomImage.path;

      if (!livingRoomImagePath.startsWith('assets/')) {
        final file = File(livingRoomImagePath);
        if (file.existsSync()) {
          return livingRoomImagePath;
        }
      } else {
        return livingRoomImagePath;
      }
    }

    return _defaultImages[0]!; // Fallback to default living room
  }

  void _sendMessage() {
    final message = _chatController.text.trim();
    if (message.isEmpty) return;

    final vm = ref.read(chatViewModelProvider.notifier);

    vm.addMessage(
      ChatMessageModel(
        text: message,
        timestamp: DateTime.now(),
        isUser: true,
        messageType: ChatMessageType.none,
      ),
    );

    _chatController.clear();
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        vm.addMessage(
          ChatMessageModel(
            text: "This is a fixed reply 🤖",
            timestamp: DateTime.now(),
            isUser: false,
            messageType: ChatMessageType.yesNo,
          ),
        );
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatViewModelProvider);
    final videoController = ref.watch(videoControllerProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Get living room background image
    final livingRoomImagePath = _getLivingRoomImage();

    return Scaffold(
      backgroundColor: const Color(0xFFF5E1C0),
      bottomNavigationBar: _buildBottomChatInput(),
      body: Stack(
        children: [
          // Living Room Background Image - ALWAYS VISIBLE at the bottom layer
          Positioned.fill(
            child: Image.asset(
              livingRoomImagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
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

          // Semi-transparent overlay to make GIF more visible
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),

          // MAIN PET GIF - POSITIONED FROM TOP with fixed size
          Positioned(
            top: 0, // Start from top
            left: 0,
            right: 0,
            child: Container(
              height: 400, // Fixed height for the GIF
              width: 300, // Fixed width for the GIF
              alignment: Alignment.topCenter,
              child: _buildMainGif(videoController),
            ),
          ),

          // Sliding chat panel with transparent background
          SlidingUpPanel(
            controller: _panelController,
            minHeight: screenHeight * 0.4,
            maxHeight: screenHeight,
            isDraggable: true,
            snapPoint: 0.5,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            backdropEnabled: true,
            backdropOpacity: 0.0,
            color: Colors.transparent,
            panelBuilder: () =>
                _buildChatPanel(messages, ref, ScrollController()),
            onPanelSlide: (pos) {
              if (!mounted) return;
              setState(() {
                _isExpanded = pos > 0.9;
                _isHalfOpen = pos > 0.4 && pos <= 0.9;
                _panelHeight =
                    (1 - pos) * (screenHeight * 0.6) + (screenHeight * 0.4);

                if (pos == 0.0 || pos == 0.5 || pos == 1.0) {
                  _gifKey++;
                }
              });
            },
            onPanelOpened: () {
              setState(() {
                _isExpanded = true;
                _isHalfOpen = false;
                _gifKey++;
              });
            },
            onPanelClosed: () {
              setState(() {
                _isExpanded = false;
                _isHalfOpen = false;
                _gifKey++;
              });
            },
          ),

          // Floating pet GIF when panel is expanded or half-open
          if (_isExpanded || _isHalfOpen)
            _buildFloatingPet(videoController, screenWidth),
        ],
      ),
    );
  }

  Widget _buildMainGif(VideoControllerState videoController) {
    return KeyedSubtree(
      key: ValueKey('main_gif_${videoController.currentGifPath}_$_gifKey'),
      child: Container(
        width: 300, // Fixed width
        height: 400, // Fixed height
        color: Colors.transparent,
        child: Image.asset(
          videoController.currentGifPath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset("assets/pet/natural.gif", fit: BoxFit.contain);
          },
        ),
      ),
    );
  }

  Widget _buildFloatingPet(
      VideoControllerState videoController,
      double screenWidth,
      ) {
    return Positioned(
      left: _petOffset.dx,
      top: _petOffset.dy,
      child: GestureDetector(
        onTap: () {
          _panelController.close();
          setState(() {
            _isExpanded = false;
            _isHalfOpen = false;
          });
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
          height: 90,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: ClipRRect(
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
        ),
      ),
    );
  }

  Widget _buildChatPanel(
      final List<ChatMessageModel> messages,
      WidgetRef ref,
      ScrollController sc,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            // Chat title
            Text(
              'Chat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            // Messages list
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: ListView.builder(
                  controller: sc,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final prev = index > 0 ? messages[index - 1] : null;
                    final showDate =
                        prev == null ||
                            !_isSameDay(prev.timestamp, msg.timestamp);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showDate) _buildDateSeparator(msg.timestamp),
                        _buildMessageBubble(msg),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomChatInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _chatController,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _buildIconButton(icon: Icons.mic, onPressed: () {}, isEnabled: false),
          const SizedBox(width: 8),
          _buildIconButton(
            icon: Icons.send,
            onPressed: _sendMessage,
            isEnabled: _chatController.text.trim().isNotEmpty,
          ),
        ],
      ),
    );
  }

  // ... rest of your methods remain exactly the same
  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isEnabled,
  }) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isEnabled
              ? [const Color(0xFFFFD288), const Color(0xFFB15600)]
              : [const Color(0x80FFD288), const Color(0x80B15600)],
        ),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: isEnabled ? onPressed : null,
      ),
    );
  }

  Widget _buildDateSeparator(DateTime timestamp) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _formatDate(timestamp),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessageModel msg) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: msg.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!msg.isUser) ...[
            _buildAvatar('assets/cat1.png'),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: msg.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: msg.isUser
                        ? Colors.blue[100]
                        : res.themes.appbarColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    msg.text,
                    style: TextStyle(
                      color: msg.isUser ? Colors.black87 : Colors.white,
                    ),
                  ),
                ),
                if (!msg.isUser && msg.messageType != ChatMessageType.none)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: _buildMessageActions(msg.messageType!),
                  ),
              ],
            ),
          ),
          if (msg.isUser) ...[
            const SizedBox(width: 8),
            _buildAvatar('assets/user_avatar.png'),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(String imagePath) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: CircleAvatar(backgroundImage: AssetImage(imagePath)),
    );
  }

  Widget _buildMessageActions(ChatMessageType messageType) {
    switch (messageType) {
      case ChatMessageType.memory:
        return _buildMemoryWidget();
      case ChatMessageType.yesNo:
        return _buildYesNoWidget();
      case ChatMessageType.none:
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMemoryWidget() {
    final memoryFrameModel = MemoryFrameModel(
      id: 'id',
      imagePath: '',
      framePath: 'assets/golden_frame.png',
      title: "",
      memoryFrameType: MemoryFrameType.rectangle.name,
      createdAt: DateTime.now(),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SingleFrameWidget(
                  res: res,
                  frameImagePath: memoryFrameModel.framePath ?? '',
                  frameTitle: memoryFrameModel.description ?? '',
                  showDescriptionText: false,
                  width: 153,
                  height: 153,
                  callback: () async {
                    final file = await ImageUtils.pickAndCropImage(
                      context,
                      frameType: memoryFrameModel.memoryFrameType ?? '',
                    );

                    if (file != null && mounted) {
                      final localfm = memoryFrameModel.copyWith(
                        imagePath: file.path ?? '',
                      );
                      await ref
                          .read(navigationServiceProvider)
                          .pushNamed('memory_edit_screen', arguments: localfm);
                    }
                  },
                  photoPath: memoryFrameModel.imagePath ?? '',
                ),
                const SizedBox(width: 12),
                _buildActionButton(icon: Icons.share, onPressed: () {}),
              ],
            ),
            const SizedBox(height: 8),
            _buildGradientButton(
              text: 'View Memory',
              onPressed: () {
                ref
                    .read(navigationServiceProvider)
                    .push(
                  MaterialPageRoute(
                    builder: (context) => const MemoryWallScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildYesNoWidget() {
    return Row(
      children: [
        _buildBorderButton(
          text: 'No',
          onPressed: () {
            ref
                .read(chatViewModelProvider.notifier)
                .addMessage(
              ChatMessageModel(
                text: "You selected: No",
                timestamp: DateTime.now(),
                isUser: true,
                messageType: ChatMessageType.none,
              ),
            );
          },
        ),
        const SizedBox(width: 12),
        _buildGradientButton(
          text: 'Yes',
          onPressed: () {
            ref
                .read(chatViewModelProvider.notifier)
                .addMessage(
              ChatMessageModel(
                text: "You selected: Yes",
                timestamp: DateTime.now(),
                isUser: true,
                messageType: ChatMessageType.none,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGradientButton({
    required String text,
    required VoidCallback onPressed,
    bool isEnabled = true,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        width: 88,
        height: 40,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isEnabled
                ? [const Color(0xFFFFD288), const Color(0xFFB15600)]
                : [const Color(0x80FFD288), const Color(0x80B15600)],
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: isEnabled
              ? [
            BoxShadow(
              color: const Color(0xFFB15600).withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBorderButton({
    required String text,
    required VoidCallback onPressed,
    bool isEnabled = true,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        width: 88,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(
            color: isEnabled
                ? const Color(0xFFB15600)
                : const Color(0x80B15600),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isEnabled
                  ? const Color(0xFFB15600)
                  : const Color(0x80B15600),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [res.themes.lightGolden, res.themes.darkGolden],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 20),
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
    if (messageDay == today.subtract(const Duration(days: 1)))
      return 'Yesterday';

    return "${dt.day}/${dt.month}/${dt.year}";
  }
}



/*import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/enum/chat_message_type.dart';
import 'package:whiskers_flutter_app/src/provider.dart';
import 'package:whiskers_flutter_app/src/styles/resources.dart';
import 'package:whiskers_flutter_app/src/styles/utils/app_styles.dart';
import '../../../common_utility/common_utility.dart';
import '../../../models/chat_message_model.dart';
import '../../../viewmodel/video/gif_controller.dart';

class ChatViewModel extends StateNotifier<List<ChatMessageModel>> {
  ChatViewModel() : super([]);

  void init() {
    state = [];
  }

  void addMessage(ChatMessageModel message) {
    state = [...state, message];
  }

  void clearMessages() {
    state = [];
  }
}

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

  final Map<int, String> _defaultImages = {
    0: 'assets/samples/living.jpg',
    1: 'assets/samples/bedroom.jpg',
    2: 'assets/samples/kitchen.jpg',
  };

  @override
  void initState() {
    super.initState();
    res = ref.read(resourceProvider);
    ref.read(chatViewModelProvider.notifier).init();
    _sheetController = DraggableScrollableController();
    _chatController.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(videoControllerProvider.notifier).updateCurrentScreen('chat');
      _sheetController?.addListener(_onSheetChanged);
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollToBottom();
      });
    });
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

  void _sendMessage() {
    final message = _chatController.text.trim();
    if (message.isEmpty) return;

    final vm = ref.read(chatViewModelProvider.notifier);

    vm.addMessage(
      ChatMessageModel(
        text: message,
        timestamp: DateTime.now(),
        isUser: true,
        messageType: ChatMessageType.none,
      ),
    );

    _chatController.clear();

    Future.delayed(const Duration(milliseconds: 150), () {
      _scrollToBottom();
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      vm.addMessage(
        ChatMessageModel(
          text: "Demo Test Response",
          timestamp: DateTime.now(),
          isUser: false,
          messageType: ChatMessageType.yesNo,
        ),
      );

      Future.delayed(const Duration(milliseconds: 150), () {
        _scrollToBottom();
      });
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted ||
          _listScrollController == null ||
          !_listScrollController!.hasClients)
        return;
      _listScrollController!.animateTo(
        _listScrollController!.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _sheetController?.removeListener(_onSheetChanged);
    _chatController.dispose();
    _scrollController.dispose();
    _sheetController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatViewModelProvider);
    final videoController = ref.watch(videoControllerProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final livingRoomImagePath = _getLivingRoomImage();

    return Scaffold(
      backgroundColor: const Color(0xFFF5E1C0),
      bottomNavigationBar: Container(
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
                  bottom: MediaQuery.of(context).viewInsets.bottom > 0
                      ? 12
                      : 24,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _chatController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',

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
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildIconButton(
                      icon: Icons.mic,
                      onPressed: () {},
                      isEnabled: false,
                    ),
                    _buildIconButton(
                      icon: Icons.send,
                      onPressed: _sendMessage,

                      isEnabled: _chatController.text.trim().isNotEmpty,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
            color: Colors.black,
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
              Image.asset(
                livingRoomImagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFFF5E1C0),
                    ),
                  );
                },
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
      WidgetRef ref,
      ScrollController sc,
      String livingRoomImagePath,
      ) {
    _listScrollController = sc;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(memoryWallBg)),
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(_isExpanded ? 0 : 24),
          topRight: Radius.circular(_isExpanded ? 0 : 24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
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
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: ListView.builder(
                  controller: sc,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
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
                                    // if (!msg.isUser && msg.messageType != ChatMessageType.none)
                                    //   Padding(
                                    //     padding: const EdgeInsets.only(top: 8),
                                    //     child: _buildMessageActions(msg.messageType!),
                                    //   ),
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
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isEnabled,
  }) {
    return IconButton(
      icon: Icon(icon, color: Color(0XFF7A7A7A), size: 28),
      onPressed: isEnabled ? onPressed : null,
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
            Image.asset(
              livingRoomImagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF5E1C0),
                  ),
                );
              },
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

  // Widget _buildMessageActions(ChatMessageType messageType) {
  //   switch (messageType) {
  //     case ChatMessageType.memory:
  //       return _buildMemoryWidget();
  //     case ChatMessageType.yesNo:
  //       return _buildYesNoWidget();
  //     case ChatMessageType.none:
  //       return const SizedBox.shrink();
  //   }
  // }

  /// MEMORY WIDGET

  // Widget _buildMemoryWidget() {
  //   final memoryFrameModel = MemoryFrameModel(
  //     id: 'id',
  //     imagePath: '',
  //     framePath: 'assets/golden_frame.png',
  //     title: "",
  //     memoryFrameType: MemoryFrameType.rectangle.name,
  //     createdAt: DateTime.now(),
  //   );
  //
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               SingleFrameWidget(
  //                 res: res,
  //                 frameImagePath: memoryFrameModel.framePath,
  //                 frameTitle: memoryFrameModel.description ?? '',
  //                 showDescriptionText: false,
  //                 width: 153,
  //                 height: 153,
  //                 callback: () async {
  //                   final file = await ImageUtils.pickAndCropImage(
  //                     context,
  //                     frameType: memoryFrameModel.memoryFrameType ?? '',
  //                   );
  //
  //                   if (file != null && mounted) {
  //                     final localfm = memoryFrameModel.copyWith(
  //                       imagePath: file.path,
  //                     );
  //                     await ref
  //                         .read(navigationServiceProvider)
  //                         .pushNamed('memory_edit_screen', arguments: localfm);
  //                   }
  //                 },
  //                 photoPath: memoryFrameModel.imagePath,
  //               ),
  //               const SizedBox(width: 12),
  //               _buildActionButton(icon: Icons.share, onPressed: () {}),
  //             ],
  //           ),
  //           const SizedBox(height: 8),
  //           _buildGradientButton(
  //             text: 'View Memory',
  //             onPressed: () {
  //               ref
  //                   .read(navigationServiceProvider)
  //                   .push(
  //                     MaterialPageRoute(
  //                       builder: (context) => const MemoryWallScreen(),
  //                     ),
  //                   );
  //             },
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  /// YES-NO

  // Widget _buildYesNoWidget() {
  //   return Row(
  //     children: [
  //       _buildBorderButton(
  //         text: 'No',
  //         onPressed: () {
  //           ref
  //               .read(chatViewModelProvider.notifier)
  //               .addMessage(
  //                 ChatMessageModel(
  //                   text: "You selected: No",
  //                   timestamp: DateTime.now(),
  //                   isUser: true,
  //                   messageType: ChatMessageType.none,
  //                 ),
  //               );
  //         },
  //       ),
  //       const SizedBox(width: 12),
  //       _buildGradientButton(
  //         text: 'Yes',
  //         onPressed: () {
  //           ref
  //               .read(chatViewModelProvider.notifier)
  //               .addMessage(
  //                 ChatMessageModel(
  //                   text: "You selected: Yes",
  //                   timestamp: DateTime.now(),
  //                   isUser: true,
  //                   messageType: ChatMessageType.none,
  //                 ),
  //               );
  //         },
  //       ),
  //     ],
  //   );
  // }

  /// GRADIENT

  // Widget _buildGradientButton({
  //   required String text,
  //   required VoidCallback onPressed,
  //   bool isEnabled = true,
  // }) {
  //   return GestureDetector(
  //     onTap: isEnabled ? onPressed : null,
  //     child: Container(
  //       width: 88,
  //       height: 40,
  //       decoration: BoxDecoration(
  //         gradient: LinearGradient(
  //           colors: isEnabled
  //               ? [const Color(0xFFFFD288), const Color(0xFFB15600)]
  //               : [const Color(0x80FFD288), const Color(0x80B15600)],
  //         ),
  //         borderRadius: BorderRadius.circular(8),
  //         boxShadow: isEnabled
  //             ? [
  //                 BoxShadow(
  //                   color: const Color(0xFFB15600).withValues(alpha: 0.3),
  //                   blurRadius: 4,
  //                   offset: const Offset(0, 2),
  //                 ),
  //               ]
  //             : null,
  //       ),
  //       child: Center(
  //         child: Text(
  //           text,
  //           style: const TextStyle(
  //             color: Colors.black,
  //             fontSize: 14,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  /// BORDER BUTTON

  // Widget _buildBorderButton({
  //   required String text,
  //   required VoidCallback onPressed,
  //   bool isEnabled = true,
  // }) {
  //   return GestureDetector(
  //     onTap: isEnabled ? onPressed : null,
  //     child: Container(
  //       width: 88,
  //       height: 40,
  //       decoration: BoxDecoration(
  //         border: Border.all(
  //           color: isEnabled
  //               ? const Color(0xFFB15600)
  //               : const Color(0x80B15600),
  //           width: 2,
  //         ),
  //         borderRadius: BorderRadius.circular(8),
  //         color: Colors.white,
  //       ),
  //       child: Center(
  //         child: Text(
  //           text,
  //           style: TextStyle(
  //             color: isEnabled
  //                 ? const Color(0xFFB15600)
  //                 : const Color(0x80B15600),
  //             fontSize: 14,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  /// ACTIO

  // Widget _buildActionButton({
  //   required IconData icon,
  //   required VoidCallback onPressed,
  // }) {
  //   return GestureDetector(
  //     onTap: onPressed,
  //     child: Container(
  //       width: 40,
  //       height: 40,
  //       decoration: BoxDecoration(
  //         shape: BoxShape.circle,
  //         gradient: LinearGradient(
  //           colors: [res.themes.lightGolden, res.themes.darkGolden],
  //         ),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black.withValues(alpha: 0.2),
  //             blurRadius: 4,
  //             offset: const Offset(0, 2),
  //           ),
  //         ],
  //       ),
  //       child: Icon(icon, color: Colors.white, size: 20),
  //     ),
  //   );
  // }

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
}*/
