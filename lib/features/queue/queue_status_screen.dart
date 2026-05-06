import 'package:flutter/material.dart';

class QueueStatusScreen extends StatelessWidget {
  const QueueStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Queue Status')),
      body: const Center(
        child: Text('Queue Status visualization goes here'),
      ),
    );
  }
}
