import 'package:flutter/material.dart';

Future<bool?> showConfirmDeleteDialog(
  BuildContext context,
  String subjectName,
) {
  return showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Delete Subject"),
      content: Text(
        "Are you sure you want to delete \"$subjectName\"?\nThis cannot be undone.",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text(
            "Delete",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
}
