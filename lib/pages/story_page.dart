import 'package:flutter/material.dart';

class StoryPage extends StatelessWidget {
  final String storyId;
  
  const StoryPage({super.key, required this.storyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('História'),
      ),
      body: Center(
        child: Text('História ID: $storyId'),
      ),
    );
  }
}