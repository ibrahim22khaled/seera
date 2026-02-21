import 'package:flutter/material.dart';

class AnimatedWaveBar extends StatefulWidget {
  final int index;
  const AnimatedWaveBar({super.key, required this.index});

  @override
  State<AnimatedWaveBar> createState() => _AnimatedWaveBarState();
}

class _AnimatedWaveBarState extends State<AnimatedWaveBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 400 + (widget.index * 100) % 600),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 4, end: 24).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 4,
          height: _animation.value,
          decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(0.8),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      },
    );
  }
}
