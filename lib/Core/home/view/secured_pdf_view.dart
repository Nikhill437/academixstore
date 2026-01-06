import 'dart:typed_data';
import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:screen_protector/screen_protector.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class SecurePDFScreen extends StatefulWidget {
  final String pdfUrl;
  final String? watermarkText; // e.g., User email or ID

  const SecurePDFScreen({
    Key? key,
    required this.pdfUrl,
    required this.watermarkText,
  }) : super(key: key);

  @override
  State<SecurePDFScreen> createState() => _SecurePDFScreenState();
}

class _SecurePDFScreenState extends State<SecurePDFScreen> {
  static const platform = MethodChannel('com.academixstore.app/security');

  Uint8List? pdfBytes;
  bool isCaptured = false;
  bool isLoading = true;
  bool hasError = false;
  String? errorMessage;
  String? pdfText;

  final TextEditingController _chatController = TextEditingController();
  final List<Map<String, String>> _chatMessages = [];
  bool _showChat = false; // Toggle chat visibility

  @override
  void initState() {
    super.initState();
    _fetchPdfInMemory();
    _preventScreenshotOn();
    if (Platform.isAndroid) {
      _enableSecureFlag();
    } else if (Platform.isIOS) {
      _startCaptureListener();
    }
  }

  @override
  void dispose() {
    _chatController.dispose();
    if (Platform.isAndroid) {
      _disableSecureFlag();
    }
    _preventScreenshotOff();
    super.dispose();
  }

  void _preventScreenshotOn() async {
    try {
      await ScreenProtector.preventScreenshotOn();
      log('Screenshot protection enabled');
    } catch (e) {
      log('Error enabling screenshot protection: $e');
    }
  }

  void _preventScreenshotOff() async {
    try {
      await ScreenProtector.preventScreenshotOff();
      log('Screenshot protection disabled');
    } catch (e) {
      log('Error disabling screenshot protection: $e');
    }
  }

  void _enableSecureFlag() {
    try {
      platform.invokeMethod("enableSecureMode");
      log('Secure mode enabled');
    } catch (e) {
      log('Error enabling secure flag: $e');
    }
  }

  void _disableSecureFlag() {
    try {
      platform.invokeMethod("disableSecureMode");
      log('Secure mode disabled');
    } catch (e) {
      log('Error disabling secure flag: $e');
    }
  }

  void _startCaptureListener() {
    platform.setMethodCallHandler((call) async {
      if (call.method == "captureChanged") {
        bool captured = call.arguments as bool;
        setState(() {
          isCaptured = captured;
        });
      }
    });
  }

  Future<void> _fetchPdfInMemory() async {
    log('Starting PDF fetch from: ${widget.pdfUrl}');

    try {
      final response = await http.get(Uri.parse(widget.pdfUrl));
      log('PDF fetch response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        pdfBytes = response.bodyBytes;
        log('PDF bytes loaded: ${pdfBytes!.length} bytes');

        try {
          final PdfDocument document = PdfDocument(inputBytes: pdfBytes!);
          pdfText = '';
          for (int i = 0; i < document.pages.count; i++) {
            pdfText =
                pdfText! +
                PdfTextExtractor(document).extractText(startPageIndex: i);
          }
          document.dispose();
          log('PDF text extracted: ${pdfText!.length} characters');
        } catch (e) {
          log('Error extracting PDF text: $e');
        }

        setState(() {
          isLoading = false;
        });
      } else {
        log('Failed to load PDF: ${response.statusCode}');
        setState(() {
          hasError = true;
          errorMessage = 'Failed to load PDF (Status: ${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      log('Error fetching PDF: $e');
      setState(() {
        hasError = true;
        errorMessage = 'Error loading PDF: $e';
        isLoading = false;
      });
    }
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty || pdfText == null) return;

    setState(() {
      _chatMessages.add({'role': 'user', 'text': message});
    });

    String answer = _findBestAnswer(message, pdfText!);

    setState(() {
      _chatMessages.add({'role': 'bot', 'text': answer});
    });

    _chatController.clear();
  }

  String _findBestAnswer(String question, String text) {
    List<String> sentences = text.split(RegExp(r'[.!?]\s+'));
    List<String> words = question.toLowerCase().split(' ');
    int maxScore = 0;
    String bestAnswer = "Sorry, I couldn't find an answer in the PDF.";

    for (String sentence in sentences) {
      int score = 0;
      for (String word in words) {
        if (sentence.toLowerCase().contains(word)) score++;
      }
      if (score > maxScore) {
        maxScore = score;
        bestAnswer = sentence;
      }
    }
    return bestAnswer;
  }

  @override
  Widget build(BuildContext context) {
    if (isCaptured) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            "Screen recording or mirroring detected.\nViewing disabled.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      );
    }

    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 20),
              Text('Loading PDF...', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );
    }

    if (hasError || pdfBytes == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                const SizedBox(height: 20),
                Text(
                  errorMessage ?? "Failed to load PDF.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                      hasError = false;
                      errorMessage = null;
                    });
                    _fetchPdfInMemory();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Secure PDF"),
        backgroundColor: Colors.black,
        actions: [
          // Chat toggle button (only show if text was extracted)
          if (pdfText != null && pdfText!.isNotEmpty)
            IconButton(
              icon: Icon(_showChat ? Icons.close : Icons.chat),
              onPressed: () {
                setState(() {
                  _showChat = !_showChat;
                });
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          // Full-screen PDF Viewer
          Stack(
            children: [
              SfPdfViewer.memory(
                pdfBytes!,
                canShowScrollHead: false,
                canShowScrollStatus: false,
              ),
              // Watermark overlay
              if (widget.watermarkText != null)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Center(
                      child: Transform.rotate(
                        angle: -0.5,
                        child: Opacity(
                          opacity: 0.15,
                          child: Text(
                            widget.watermarkText!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Sliding chat panel
          if (_showChat && pdfText != null && pdfText!.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Handle bar
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    // Title
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Ask about this PDF',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    // Chat messages
                    Expanded(
                      child: _chatMessages.isEmpty
                          ? Center(
                              child: Text(
                                'Ask a question about the PDF content',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: _chatMessages.length,
                              itemBuilder: (context, index) {
                                final msg = _chatMessages[index];
                                final isUser = msg['role'] == 'user';
                                return Align(
                                  alignment: isUser
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                          0.7,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isUser
                                          ? Colors.blue
                                          : Colors.grey[300],
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      msg['text']!,
                                      style: TextStyle(
                                        color: isUser
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    // Input field
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border(
                          top: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      child: SafeArea(
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _chatController,
                                decoration: InputDecoration(
                                  hintText: 'Type your question...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),
                                onSubmitted: _sendMessage,
                              ),
                            ),
                            const SizedBox(width: 8),
                            CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () {
                                  _sendMessage(_chatController.text);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
