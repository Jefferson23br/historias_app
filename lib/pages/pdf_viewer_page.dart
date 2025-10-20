import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PdfViewerPage extends StatefulWidget {
  final String pdfUrl;
  final String title;
  final String? pdfUrl2;

  const PdfViewerPage({
    super.key,
    required this.pdfUrl,
    required this.title,
    this.pdfUrl2,
  });

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late String currentUrl;

  @override
  void initState() {
    super.initState();
    currentUrl = widget.pdfUrl;
  }

  void _switchToImageVersion() {
    setState(() {
      currentUrl = widget.pdfUrl;
    });
  }

  void _switchToTextVersion() {
    if (widget.pdfUrl2 != null && widget.pdfUrl2!.isNotEmpty) {
      setState(() {
        currentUrl = widget.pdfUrl2!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasTextVersion = widget.pdfUrl2 != null && widget.pdfUrl2!.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          // Botões de tipo de leitura
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _switchToImageVersion,
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  label: const Text("Leitura com Imagens"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade300,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: hasTextVersion ? _switchToTextVersion : null,
                  icon: const Icon(Icons.text_fields),
                  label: const Text("Leitura em Texto"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        hasTextVersion ? Colors.pink.shade300 : Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0),
          Expanded(
            child: PDF().cachedFromUrl(
              currentUrl,
              placeholder: (progress) =>
                  Center(child: Text('$progress %', style: const TextStyle(fontSize: 18))),
              errorWidget: (error) =>
                  Center(child: Text('Erro ao carregar PDF: $error')),
            ),
          ),
        ],
      ),
    );
  }
}