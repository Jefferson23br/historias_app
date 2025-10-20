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
  bool _isShowingTextVersion = false;

  @override
  void initState() {
    super.initState();
    currentUrl = widget.pdfUrl;
  }

  void _switchToImageVersion() {
    setState(() {
      currentUrl = widget.pdfUrl;
      _isShowingTextVersion = false;
    });
  }

  void _switchToTextVersion() {
    if (widget.pdfUrl2 != null && widget.pdfUrl2!.isNotEmpty) {
      setState(() {
        currentUrl = widget.pdfUrl2!;
        _isShowingTextVersion = true;
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
          // Botões de tipo de leitura com Wrap para evitar overflow
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _isShowingTextVersion ? _switchToImageVersion : null,
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  label: const Text("Leitura com Imagens"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !_isShowingTextVersion
                        ? Colors.purple.shade300
                        : Colors.grey.shade300,
                    foregroundColor: !_isShowingTextVersion
                        ? Colors.white
                        : Colors.black54,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                if (hasTextVersion)
                  ElevatedButton.icon(
                    onPressed: !_isShowingTextVersion ? _switchToTextVersion : null,
                    icon: const Icon(Icons.text_fields),
                    label: const Text("Leitura em Texto"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isShowingTextVersion
                          ? Colors.pink.shade300
                          : Colors.grey.shade300,
                      foregroundColor: _isShowingTextVersion
                          ? Colors.white
                          : Colors.black54,
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
            child: Container(
              key: ValueKey(currentUrl), // ← Key no Container, não no PDF
              child: PDF().cachedFromUrl(
                currentUrl,
                placeholder: (progress) =>
                    Center(child: Text('$progress %', style: const TextStyle(fontSize: 18))),
                errorWidget: (error) =>
                    Center(child: Text('Erro ao carregar PDF: $error')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}