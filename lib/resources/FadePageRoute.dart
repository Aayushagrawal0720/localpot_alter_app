import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

PageRouteBuilder fadePageRoute(BuildContext context, Widget page) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Offset begin = const Offset(0, 1);
        // Offset end = Offset.zero;
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeIn;
        final tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);
        return FadeTransition(
          opacity: offsetAnimation,
          // position: offsetAnimation,
          child: child,
        );
      });
}
