import 'dart:math';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // Animation -- Circle
  double _buttonRadius = 100;
  double _basicSize = 15;

  // Animation -- background opening
  final Tween<double> _backgroundScale = Tween<double>(begin: 0.0, end: 1.0);

  // Animation -- Star rotating
  AnimationController? _starIconAnimationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _starIconAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _starIconAnimationController!.repeat();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _pageBackground(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _circularAnimationButton(),
                _starAnimationIcon(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _pageBackground() {
    return TweenAnimationBuilder(
      tween: _backgroundScale,
      curve: Curves.easeInOutCubicEmphasized,
      duration: const Duration(seconds: 3),
      builder: (_context, double _scale, _child) {
        return Transform.scale(
          scale: _scale,
          child: _child,
        );
      },
      child: Container(
        color: Colors.blue,
      ),
    );
  }

  Widget _circularAnimationButton() {
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _buttonRadius += _buttonRadius >= 200 ? -100 : 100;
            _basicSize += _basicSize >= 30 ? -15 : 15;
          });
        },
        child: AnimatedContainer(
          curve: Curves.easeInOutCubicEmphasized,
          duration: const Duration(
            seconds: 2,
          ),
          height: _buttonRadius,
          width: _buttonRadius,
          decoration: BoxDecoration(
            color: Colors.purpleAccent,
            borderRadius: BorderRadius.circular(_buttonRadius),
          ),
          child: AnimatedAlign(
            curve: Curves.bounceInOut,
            alignment: Alignment.center,
            duration: const Duration(
              seconds: 4,
            ),
            child: Text(
              "Basic!",
              style: TextStyle(
                color: Colors.white,
                fontSize: _basicSize,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _starAnimationIcon() {
    return AnimatedBuilder(
      animation: _starIconAnimationController!.view,
      builder: (_buildContext, _child) {
        return Transform.rotate(
          angle: _starIconAnimationController!.value * 2 * pi,
          child: _child,
        );
      },
      child: const Icon(
        Icons.star_purple500,
        size: 100,
        color: Colors.yellowAccent,
      ),
    );
  }
}
