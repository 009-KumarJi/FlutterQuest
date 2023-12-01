import 'package:flutter/cupertino.dart';

class InfoCard extends StatelessWidget {
  final Widget child;
  final double height, width;

  const InfoCard({
    required this.height,
    required this.width,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: CupertinoColors.darkBackgroundGray,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(37, 37, 37, 1),
            blurRadius: 5,
          ),
        ],
      ),
      child: child,
    );
  }
}
