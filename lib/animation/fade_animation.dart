import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AnimationType { opacity, translateX }

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;
  final bool isSliver; 

  const FadeAnimation({required this.delay, required this.child, Key? key, this.isSliver = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<AnimationType>()
      ..add(AnimationType.opacity, Tween(begin: 0.0, end: 1.0),
        const Duration(milliseconds: 500),)
      ..add(
        AnimationType.translateX,
        Tween(begin: -30.0, end: 1.0),
        const Duration(milliseconds: 500),
      );
    
    return PlayAnimation<MultiTweenValues<AnimationType>>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, value){
        return isSliver ? SliverOpacity(
          opacity: value.get(AnimationType.opacity),
          sliver: child,
        ) : Opacity(
          opacity: value.get(AnimationType.opacity),
          child: Transform.translate(
              offset: Offset(0,value.get(AnimationType.translateX)), child: child),
        );
      },
    );
  }
}