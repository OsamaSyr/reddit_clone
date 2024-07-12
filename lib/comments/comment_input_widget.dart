import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentInput extends StatefulWidget {
  final Function(String, String?) onSubmit;
  final String? parentId;

  const CommentInput({super.key, required this.onSubmit, this.parentId});

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final TextEditingController _controller = TextEditingController();

  void _submit() {
    if (_controller.text.isNotEmpty) {
      widget.onSubmit(_controller.text, widget.parentId);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.sizeOf(context).height * 0.03),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1D1B1D),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: TextField(
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                controller: _controller,
                decoration: const InputDecoration(
                    hintText: 'Add a comment...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(CupertinoIcons.arrow_right, color: Colors.white),
              onPressed: _submit,
            ),
          ),
        ],
      ),
    );
  }
}
