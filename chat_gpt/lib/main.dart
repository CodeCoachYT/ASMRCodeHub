import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const ChatGPT());

class ChatGPT extends StatelessWidget {
  const ChatGPT({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CHAT-GPT - Flutter',
      home: Scaffold(
        body: Builder(
          builder: (context) => const ChatContent(),
        ),
      ),
    );
  }
}

Future<String> getChatGptResponse({required String question}) async {
  const apiURL = 'https://api.openai.com/v1/completions';
  // Insert your API KEY here.
  const apiKey = '<YOUR API KEY HERE>';
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  final requestBody = json.encode({
    "model": "text-davinci-003",
    'prompt': question,
    'max_tokens': 1000,
    'temperature': 0.5,
  });

  final response = await http.post(
    Uri.parse(apiURL),
    headers: headers,
    body: requestBody,
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    final output = responseData['choices'][0]['text'].toString();
    return output;
  } else {
    return 'Failed to connect to CHAT-GPT API.\nMake sure you inserted your API KEY';
  }
}

class Message {
  Message({
    required this.isResponse,
    required this.message,
  });
  final bool isResponse;
  String message;
}

class ChatContent extends StatefulWidget {
  const ChatContent({super.key});

  @override
  State<ChatContent> createState() => _ChatContentState();
}

class _ChatContentState extends State<ChatContent> {
  final List<Message> messages = [];
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.85),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Chat GPT'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return MessageBubble(
                    isResponse: message.isResponse,
                    message: message.message,
                    senderName: message.isResponse ? 'Chat-GPT' : 'You',
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 5.0,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 15.0,
                        ),
                      ),
                      onSubmitted: (value) async {
                        await sendQuestion();
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {
                      await sendQuestion();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> sendQuestion() async {
    if (controller.text.isEmpty) return;
    final question = controller.text;
    controller.text = '';
    setState(() {
      messages.add(
        Message(
          isResponse: false,
          message: question,
        ),
      );
    });
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      messages.add(
        Message(
          isResponse: true,
          message: '',
        ),
      );
    });
    await Future.delayed(const Duration(milliseconds: 500));

    final response = (await getChatGptResponse(question: question)).trim();

    setState(() {
      messages[messages.length - 1].message = response;
    });
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final String senderName;
  final bool isResponse;

  const MessageBubble({
    super.key,
    required this.message,
    required this.senderName,
    required this.isResponse,
  });

  @override
  Widget build(BuildContext context) {
    const sharpEdge = Radius.circular(0);
    const roundedEdge = Radius.circular(16);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          isResponse ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isResponse ? const CircleAvatar() : const SizedBox(),
        const SizedBox(
          width: 12.0,
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          decoration: BoxDecoration(
            color: isResponse ? Colors.grey.shade200 : Colors.green.shade200,
            borderRadius: BorderRadius.only(
              topLeft: roundedEdge,
              topRight: roundedEdge,
              bottomLeft: isResponse ? sharpEdge : roundedEdge,
              bottomRight: isResponse ? roundedEdge : sharpEdge,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                senderName,
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              if (message.isEmpty)
                Row(
                  children: const [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator.adaptive(),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text('CHat GPT is typing ...')
                  ],
                )
              else
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    message,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                )
            ],
          ),
        )
      ],
    );
  }
}
