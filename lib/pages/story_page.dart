import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart'; 

class StoryPage extends StatelessWidget {
  final String storyId;
  final String pdfUrl; 
  final String title;  

  const StoryPage({
    super.key,
    required this.storyId,
    required this.pdfUrl, 
    required this.title,  
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title), 
      ),
      body: PDF().cachedFromUrl(
        pdfUrl,
        placeholder: (progress) => Center(child: Text('$progress%')),
        errorWidget: (error) => Center(child: Text('Erro ao carregar PDF: $error')),
      ),
    );
  }
}