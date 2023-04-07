

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;


class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {

  final Map<String,HighlightedWord> _highlight = {
    'flutter': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'voice': HighlightedWord(
        onTap: () => print('voice'),
        textStyle: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold
        )
    ),
    'subscribe': HighlightedWord(
        onTap: () => print('subscribe'),
        textStyle: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold
        )
    ),
    'like': HighlightedWord(
      onTap: () => print('like'),
      textStyle: const TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold
      ),
    ),
    'comment': HighlightedWord(
      onTap: () => print('comment'),
      textStyle: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold
      ),
    ),
  };


  stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  String _text = 'Press the button and Start speaking';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
    reverse: true,
    child: Container(
    padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
    child: TextHighlight(
    text: _text,
    words: _highlight,
    textStyle: const TextStyle(
    fontSize: 20.0,
    color: Colors.black,
    fontWeight: FontWeight.w400
    ),),
    ),
    ),
    );
  }
  void _listen() async{
    if (!_isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val')
      );
      if(available) {
        setState(() => _isListening = true);
        _speechToText.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
     _speechToText.stop();
    }
  }
}