import 'package:flutter/material.dart';
import 'package:flutterdevscaffold/app/widgets/AppTitleBar.dart';

void main() {
  runApp(
    MaterialApp(
      builder: (context, child) {
        final top = MediaQuery.of(context).padding.top;
        return child!;
      },
      home: Scaffold(
        appBar: AppTitleBar(title: const Text('My App')),
        body: const AppWidget(),
      ),
    ),
  );
}

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.viewPaddingOf(context).top;
    return Container(
      color: Colors.red,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Text(
          top.toString(),
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
