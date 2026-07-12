import 'package:flutter/material.dart';

Future<int?> askHours(BuildContext context) async {
  final ctrl = TextEditingController();
  return showDialog<int>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("How many hours can you study today?"),
      content: TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(hintText: "e.g. 3"),
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.pop(context, int.tryParse(ctrl.text)),
          child: const Text("OK"),
        )
      ],
    ),
  );
}
