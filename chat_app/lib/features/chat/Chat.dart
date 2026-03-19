import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:llama_cpp_dart/llama_cpp_dart.dart';
import 'package:llama_cpp_dart/src/llama_cpp.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreen();
}
class _ChatScreen extends State<ChatScreen> {
  final TextEditingController questionController = TextEditingController();
  Llama ? llama;
  String responseText = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initModel();
  }
  Future<String> copyModelFromAssets() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/Phi-3-mini.gguf');

    // If already copied, skip
    if (await file.exists()) {
      return file.path;
    }

    // Load from assets
    final data = await rootBundle.load('assets/models/Phi-3-mini-4k-instruct-q4.gguf');

    final bytes = data.buffer.asUint8List();

    await file.writeAsBytes(bytes);

    return file.path;
  }
  Future<void> _initModel() async {
    final modelpath = await copyModelFromAssets();
    llama = Llama(modelpath);
    setState(() {});
  }
  void handleSend() async {
    print(questionController.text);
    if (questionController.text.isEmpty || llama==null) return;
      setState(() {
        isLoading = true;
        responseText = "Thinking...";
      });
    print(questionController.text);
    await Future.delayed(const Duration(milliseconds: 50));
    final prompt = "<|user|>\n${questionController.text}\n<|assistant|>";

    String full_response = "";
    llama!.setPrompt(prompt);
   await for (final token in llama!.generateText()) {
     full_response +=token;
     setState(() {
       responseText=full_response;
     });
   }
    setState(() {
      isLoading = false;
    });
    print(full_response);
    questionController.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Screen')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding:EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child:TextField(
                controller: questionController,
                decoration:InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                    hintText: isLoading ? "Thinking..." : "Ask a question",
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    suffixIcon: Padding(
                        padding: const EdgeInsets.only(right:8.0),
                        child: IconButton(onPressed: handleSend, icon: const Icon(Icons.arrow_right, size: 50,), style:IconButton.styleFrom(padding:const EdgeInsets.all(8))),
                    ),
                ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Text(responseText,style: const TextStyle(fontSize: 16, color: Colors.black87)),
          )
        ],
      )
    );
  }
}