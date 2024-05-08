

import 'package:flutter/material.dart';

class ReviewPage extends StatefulWidget {
  final Function(String) onCommentAdded;
  

  const ReviewPage({Key? key, required this.onCommentAdded}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Comment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(labelText: 'Enter your comment'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final comment = _commentController.text;
                widget.onCommentAdded(comment);
                Navigator.pop(context);
              },
              child: const Text('Add Comment'),
            ),
          ],
        ),
      ),
    );
  }
}
