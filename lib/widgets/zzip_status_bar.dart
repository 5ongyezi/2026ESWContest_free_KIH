import 'package:flutter/material.dart';
import '../data/sleep_mode_store.dart';

class ZzipStatusBar extends StatefulWidget {
  const ZzipStatusBar({super.key});

  @override
  State<ZzipStatusBar> createState() => _ZzipStatusBarState();
}

class _ZzipStatusBarState extends State<ZzipStatusBar> {
  @override
  void initState() {
    super.initState();
    SleepModeStore.instance.addListener(_onChange);
  }

  @override
  void dispose() {
    SleepModeStore.instance.removeListener(_onChange);
    super.dispose();
  }

  void _onChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final isSleeping = SleepModeStore.instance.isSleeping;
    final text = isSleeping ? 'SLEEPING..ZZ' : 'ZZIP Ready';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: double.infinity,
      height: 48,
      color: isSleeping ? const Color(0xFFA71943) : const Color(0xFFE43F68),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 18),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: _ThreeDText(key: ValueKey(text), text: text),
      ),
    );
  }
}

class _ThreeDText extends StatelessWidget {
  final String text;
  const _ThreeDText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Transform.translate(
          offset: const Offset(1.4, 2),
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF7A0F30),
              fontWeight: FontWeight.w900,
              fontSize: 15,
              letterSpacing: 1,
            ),
          ),
        ),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 15,
            letterSpacing: 1,
            shadows: [
              Shadow(offset: Offset(0.5, 1), blurRadius: 1, color: Color(0xFFFF8FA7)),
            ],
          ),
        ),
      ],
    );
  }
}