import 'package:devappsdk/devappsdk.dart';
import 'package:flutter/material.dart';
import 'package:kdialogs/kdialogs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String input = "";
  String text = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 200,
              child: TextFormField(
                decoration: const InputDecoration(label: Text("Name")),
                onChanged: (value) => input = value,
              ),
            ),
            IconButton(
              onPressed: () async {
                try {
                  final value = await DevAppManager().readValue(input);
                  setState(() {
                    text = value ?? "not-found";
                  });
                } catch (err) {
                  if (!context.mounted) return;
                  showBottomAlertKDialog(context, message: err.toString());
                }
              },
              icon: const Icon(Icons.search),
            ),
            const SizedBox(height: 20.0),
            Text(text),
          ],
        ),
      ),
    );
  }
}
