import 'package:flutter/material.dart';

class VideoControllingButton extends StatefulWidget {
  const VideoControllingButton(
      {super.key, required this.icon, required this.onTap});

  final IconData icon;
  final Function() onTap;

  @override
  State<VideoControllingButton> createState() => _VideoControllingButtonState();
}

class _VideoControllingButtonState extends State<VideoControllingButton> {
  double iconSize = 40;

  void onPressAnimation() {
    setState(() {
      iconSize = 50;
    });
    Future.delayed(const Duration(milliseconds: 100)).then(
      (value) => {
        setState(() {
          setState(() {
            iconSize = 40;
          });
        })
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressAnimation();
        widget.onTap();
      },
      child: Icon(
        widget.icon,
        color: Colors.white,
        size: iconSize,
      ),
    );
  }
}
