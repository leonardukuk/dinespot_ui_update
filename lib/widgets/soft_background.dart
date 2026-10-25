import 'package:flutter/material.dart';

/// A soft gradient background with two blurred colour "orbs".
/// Wrap a screen's body with it for a warmer, more polished look.
class SoftBackground extends StatelessWidget {
  const SoftBackground({
    super.key,
    required this.child,
    this.top = const Color(0xFFFFF1E0),
    this.middle = const Color(0xFFFAF7F2),
    this.bottom = const Color(0xFFF6E3D3),
    this.orb = const Color(0xFFC66B3D),
  });

  final Widget child;
  final Color top;
  final Color middle;
  final Color bottom;
  final Color orb;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [top, middle, bottom],
              ),
            ),
          ),
        ),
        Positioned(
          top: -90,
          right: -70,
          child: IgnorePointer(
            child: _Orb(size: 260, color: orb.withValues(alpha: 0.13)),
          ),
        ),
        Positioned(
          bottom: -110,
          left: -80,
          child: IgnorePointer(
            child: _Orb(size: 300, color: orb.withValues(alpha: 0.10)),
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
