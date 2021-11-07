import 'package:flutter/material.dart';
import 'dart:math' as math;

class FlashcardWidget extends StatefulWidget {
  final String frontText;
  final String reverseText;
  final Color color;

  const FlashcardWidget({
    Key? key,
    required this.color,
    required this.frontText,
    required this.reverseText,
  }) : super(key: key);

  @override
  _FlashcardWidgetState createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget> with SingleTickerProviderStateMixin {
  final double _size = 250.0;

  late AnimationController _controller;
  late Animation<double> _flipAnimation;

  bool _flipped = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500), value: 1.0);
    _flipAnimation = Tween<double>(begin: math.pi, end: 0.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    Widget _card = SizedBox(
      width: _size,
      height: _size,
      child: Card(
        color: widget.color,
        child: Center(
          child: GestureDetector(
            child: Container(
              width: 230.0,
              height: 150.0,
              color: Colors.transparent,
              child: _flashcardText(),
            ),
            onTap: () {
              print('flashcard pressed');
              _controller.forward(from: 0.0);
              setState(() => _flipped = !_flipped);
            },
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _controller,
      child: _card,
      builder: (BuildContext context, Widget? child) => Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(_flipAnimation.value),
        child: child,
        alignment: FractionalOffset.center,
      ),
    );
  }

  Widget _flashcardText() {
    return Center(
      child: Text(
        _flipped ? widget.reverseText : widget.frontText,
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
