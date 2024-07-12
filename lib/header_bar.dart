import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoHeaderBar extends ConsumerWidget {
  const VideoHeaderBar(this.videoHeight, {super.key});
  final double videoHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    return ListTile(
        leading: const Icon(
          size: 40,
          Icons.close,
          color: Colors.white,
        ),
        title: (videoHeight >= size.height * 0.8)
            ? RichText(
                text: const TextSpan(
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                    text: 'r/',
                    children: [
                      TextSpan(
                          text: 'OsamaAbdullah',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                    ]),
                textAlign: TextAlign.center,
              )
            : const SizedBox(),
        trailing: (videoHeight >= size.height * 0.8)
            ? const Icon(
                size: 40,
                Icons.more_horiz,
                color: Colors.white,
              )
            : const SizedBox());
  }
}
