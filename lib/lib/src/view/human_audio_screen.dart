import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:whiskers_flutter_app/src/provider.dart';
import 'package:whiskers_flutter_app/src/styles/resources.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../common_utility/common_utility.dart';
import '../widgets/common_widgets/back_button.dart';
import '../widgets/common_widgets/top_dog_paw_widget.dart';

class HumanAudioScreen extends ConsumerStatefulWidget {
  const HumanAudioScreen({super.key});

  @override
  ConsumerState<HumanAudioScreen> createState() => _HumanAudioScreenState();
}

class _HumanAudioScreenState extends ConsumerState<HumanAudioScreen> {
  late Resources res;
  bool _isListening = false;
  bool _isListenedSuccessfully = false;
  String _recognizedText = '';
  final SpeechToText _speechToText = SpeechToText();

  @override
  void initState() {
    super.initState();
    res = ref.read(resourceProvider);
    _initSpeech();
  }

  void _initSpeech() async {
    await _speechToText.initialize();
    _speechToText.statusListener = (status) {
      setState(() {
        _isListening = _speechToText.isListening;
      });
    };
    setState(() {});
  }

  @override
  void dispose() {
    _speechToText.cancel();
    super.dispose();
  }

  void _listenToAudio() async {
    setState(() {
      _isListening = true;
      _isListenedSuccessfully = false;
      _recognizedText = '';
    });

    if (_speechToText.isAvailable) {
      _speechToText.listen(
        onResult: (result) {
          setState(() {
            _recognizedText = result.recognizedWords;
            _isListenedSuccessfully = _recognizedText.toLowerCase().trim() == 'hi joey.';
          });
        },
        listenFor: const Duration(seconds: 5), // Listen for 5 seconds
        pauseFor: const Duration(seconds: 3), // Pause for 3 seconds if no speech
      );
    } else {
      setState(() {
        _isListening = false;
      });
      // Optionally show an error message to the user
      print("The user has denied the use of speech recognition.");
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(statusBarHandler).setStatusBarColor(res.themes.pureWhite);
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Learning Your Voice',
          style: res.themes.appStyle.interBold120,
        ),
        toolbarHeight: 72,
        leadingWidth: 30,
        // leading: GestureDetector(
        //   onTap: () {
        //     Navigator.of(context).pop();
        //   },
        //   child: Padding(
        //     padding: const EdgeInsets.only(left: 12.0),
        //     child: SizedBox(width: 30, child: Iconify(Ic.baseline_less_than)),
        //   ),
        // ),
        leading: commonBackButton(context),
      ),
      body: Stack(
        children: [
          // Background Paw SVGs
          Positioned(
            top: 0,
            right: 0,
            child: Transform.rotate(
              angle: 0.5, // Adjust angle as per Figma
              child: SvgPicture.asset(
                pawSvg,
                width: 200,
                height: 200,
                colorFilter: ColorFilter.mode(Color(0x1A935B00), BlendMode.srcIn),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 10,
            child: Transform.rotate(
              angle: -0.30, // Adjust angle as per Figma
              child: SvgPicture.asset(
                pawSvg,
                width: 200,
                height: 200,
                colorFilter: ColorFilter.mode(Color(0x1A935B00), BlendMode.srcIn),
              ),
            ),
          ),
          Center(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // const SizedBox(height: 20),
                    Container(
                      height: 300,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage(cat1IMG),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Please repeat the words, "Hi Joey."',
                      style: res.themes.appStyle.black50015,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _recognizedText,
                      style: res.themes.appStyle.black50015,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: _isListening ? null : _listenToAudio,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isListening ? Colors.grey : Colors.black,
                        ),
                        child: _isListening
                            ? const Center(child: CircularProgressIndicator(color: Colors.white))
                            : Image.asset(audioPng),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_isListenedSuccessfully)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 50,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}