import 'package:flutter/material.dart';

class LegalInformationScreen extends StatelessWidget {
  final String title;
  final String content;

  const LegalInformationScreen({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: SafeArea(
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 15.0,
              height: 1.8,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
