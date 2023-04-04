import 'package:flutter/material.dart';
import 'package:selectable_code_view/selectable_code_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final dartResponses = {
    "id": "chatcmpl-717yOL6BBGn0RLenkG6OAGIuUjxo6",
    "object": "chat.completion",
    "created": 1680503332,
    "model": "gpt-3.5-turbo-0301",
    "usage": {"prompt_tokens": 21, "completion_tokens": 615, "total_tokens": 636},
    "choices": [
      {
        "message": {
          "role": "assistant",
          "content":
              "Sure, here's a sample code for generating the fibonacci series using Dart and Flutter:\n\n```dart\nimport 'package:flutter/material.dart';\n\nvoid main() => runApp(MyApp());\n\nclass MyApp extends StatelessWidget {\n  @override\n  Widget build(BuildContext context) {\n    return MaterialApp(\n      title: 'Fibonacci Series App',\n      home: FibonacciPage(),\n    );\n  }\n}\n\nclass FibonacciPage extends StatefulWidget {\n  @override\n  _FibonacciPageState createState() => _FibonacciPageState();\n}\n\nclass _FibonacciPageState extends State<FibonacciPage> {\n  final TextEditingController _controller = TextEditingController();\n  List<int> _fibonacciSequence = [];\n\n  void _generateSequence(int limit) {\n    int f0 = 0, f1 = 1;\n    _fibonacciSequence = [f0, f1];\n    for (int i = 2; i <= limit; i++) {\n      int f = f0 + f1;\n      _fibonacciSequence.add(f);\n      f0 = f1;\n      f1 = f;\n    }\n  }\n\n  @override\n  Widget build(BuildContext context) {\n    return Scaffold(\n      appBar: AppBar(\n        title: Text('Fibonacci Series App'),\n      ),\n      body: Padding(\n        padding: const EdgeInsets.all(16.0),\n        child: Column(\n          mainAxisAlignment: MainAxisAlignment.center,\n          children: <Widget>[\n            TextField(\n              controller: _controller,\n              keyboardType: TextInputType.number,\n              decoration: InputDecoration(\n                labelText: 'Enter the limit of the Fibonacci series:',\n              ),\n            ),\n            SizedBox(height: 16.0),\n            RaisedButton(\n              child: Text('Generate Sequence'),\n              onPressed: () {\n                int limit = int.tryParse(_controller.text) ?? 0;\n                if (limit > 0) {\n                  setState(() {\n                    _generateSequence(limit);\n                  });\n                }\n              },\n            ),\n            SizedBox(height: 16.0),\n            Text(\n              'Fibonacci Series:',\n              style: TextStyle(fontWeight: FontWeight.bold),\n            ),\n            Text(\n              _fibonacciSequence.join(', '),\n              style: TextStyle(fontSize: 18.0),\n            ),\n          ],\n        ),\n      ),\n    );\n  }\n}\n```\n\nThis code creates a simple Flutter app with a `TextField` and a `RaisedButton` for generating the Fibonacci series up to a specified limit. When the button is pressed, the sequence is generated using the `_generateSequence()` method, which applies the formula `f(n) = f(n-1) + f(n-2)` to calculate each new term of the sequence.\n\nThe results are displayed in a `Text` widget below the button. The `Text` widget is updated using the `setState()` method to trigger a rebuild of the widget tree whenever the state of the app changes.\n\nNote that this code does not include any error handling or input validation logic, so you may want to add that if you plan to use it in a real-world app.",
        },
        "finish_reason": "stop",
        "index": 0,
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Selectable Code View',
          ),
        ),
        body: SelectableCodeView(
          code: getCodeFromResponses(dartResponses) ?? '', // Code text
          language: Language.JAVASCRIPT, // Language
          languageTheme: LanguageTheme.vscodeDark(), // Theme
          fontSize: 12.0, // Font size
          withZoom: true, // Enable/Disable zoom icon controls
          withLinesCount: true, // Enable/Disable line number
          expanded: false, // Enable/Disable container expansion
        ),
      ),
    );
  }

  String? getCodeFromResponses(Map<String, dynamic> res) {
    final content = (res['choices'] as List)[0]['message']['content'].toString();
    final code = content.split("```");
    print('code length = ${code.length}');
    if (code.length >= 3) {
      String mainCode = code[1];
      String firstSection = '/*';
      String commentSection = '/*';
      for (int i = 2; i < code.length; i++) {
        firstSection += code[0];
        commentSection += code[i];
      }
      firstSection += '*/\n';
      commentSection += '*/';
      return '$firstSection$mainCode$commentSection';
    } else if (code.length == 2) {
      String firstSection = '/*${code[0]}*/\n';
      return "$firstSection${code[1]}";
    } else if (code.length == 1) {
      return code[0];
    }
    return null;
  }
}
