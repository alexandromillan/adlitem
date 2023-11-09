import 'package:flutter/material.dart';

class EditOrder extends StatefulWidget {
  const EditOrder({Key? key, this.order}) : super(key: key);
  final order;
  @override
  _EditOrderState createState() => _EditOrderState();
}

class _EditOrderState extends State<EditOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit order'),
      ),
      body: Container(),
    );
  }
}
