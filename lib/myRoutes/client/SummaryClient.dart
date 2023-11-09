import 'package:flutter/material.dart';

class SummaryProfileClient extends StatefulWidget {
  const SummaryProfileClient({Key? key}) : super(key: key);

  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<SummaryProfileClient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary Client'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [],
            )
          ],
        ),
      ),
    );
  }
}
