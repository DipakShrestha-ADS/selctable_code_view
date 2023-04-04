import 'package:flutter/material.dart';
import 'package:selectable_code_view/selectable_code_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  final code =
      "import 'package:flutter/material.dart';\n\nvoid main() => runApp(MyApp());\n\nclass MyApp extends StatelessWidget {\n  @override\n  Widget build(BuildContext context) {\n    return MaterialApp(\n      title: 'Fibonacci Series App',\n      home: FibonacciPage(),\n    );\n  }\n}\n\nclass FibonacciPage extends StatefulWidget {\n  @override\n  _FibonacciPageState createState() => _FibonacciPageState();\n}\n\nclass _FibonacciPageState extends State<FibonacciPage> {\n  final TextEditingController _controller = TextEditingController();\n  List<int> _fibonacciSequence = [];\n\n  void _generateSequence(int limit) {\n    int f0 = 0, f1 = 1;\n    _fibonacciSequence = [f0, f1];\n    for (int i = 2; i <= limit; i++) {\n      int f = f0 + f1;\n      _fibonacciSequence.add(f);\n      f0 = f1;\n      f1 = f;\n    }\n  }\n\n  @override\n  Widget build(BuildContext context) {\n    return Scaffold(\n      appBar: AppBar(\n        title: Text('Fibonacci Series App'),\n      ),\n      body: Padding(\n        padding: const EdgeInsets.all(16.0),\n        child: Column(\n          mainAxisAlignment: MainAxisAlignment.center,\n          children: <Widget>[\n            TextField(\n              controller: _controller,\n              keyboardType: TextInputType.number,\n              decoration: InputDecoration(\n                labelText: 'Enter the limit of the Fibonacci series:',\n              ),\n            ),\n            SizedBox(height: 16.0),\n            RaisedButton(\n              child: Text('Generate Sequence'),\n              onPressed: () {\n                int limit = int.tryParse(_controller.text) ?? 0;\n                if (limit > 0) {\n                  setState(() {\n                    _generateSequence(limit);\n                  });\n                }\n              },\n            ),\n            SizedBox(height: 16.0),\n            Text(\n              'Fibonacci Series:',\n              style: TextStyle(fontWeight: FontWeight.bold),\n            ),\n            Text(\n              _fibonacciSequence.join(', '),\n              style: TextStyle(fontSize: 18.0),\n            ),\n          ],\n        ),\n      ),\n    );\n  }\n}";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Selectable Code View',
          ),
        ),
        body: Center(
          child: SelectableCodeView(
            code: code, // Code text
            language: Language.JAVASCRIPT, // Language
            languageTheme: LanguageTheme.vscodeDark(), // Theme
            fontSize: 12.0, // Font size
            withZoom: true, // Enable/Disable zoom icon controls
            withLinesCount: true, // Enable/Disable line number
            expanded: false, // Enable/Disable container expansion
          ),
        ),
      ),
    );
  }
}
