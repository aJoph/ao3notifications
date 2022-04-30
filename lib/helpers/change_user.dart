import 'package:ao3notifications/models/ao3_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeUserDialog extends StatefulWidget {
  const ChangeUserDialog({Key? key}) : super(key: key);

  @override
  State<ChangeUserDialog> createState() => ChangeUserDialogState();
}

class ChangeUserDialogState extends State<ChangeUserDialog> {
  @override
  final _key = GlobalKey<FormState>();
  final _usernameTextEditingController = TextEditingController();

  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _usernameTextEditingController,
              maxLength: 25,
              validator: (text) {
                if (text == null || text.isEmpty || text == "") {
                  return "Please input some text.";
                }
                if (text.length > 25) {
                  return "Comically large text not allowed.";
                }
                return null;
              },
              decoration: const InputDecoration(
                label: Text("Username"),
              ),
            )
          ],
        ),
      ),
      actions: <TextButton>[
        TextButton(
            onPressed: () => _cancelDialog(context),
            child: const Text("Cancel")),
        TextButton(
            onPressed: () => _acceptDialog(context),
            child: const Text("Accept")),
      ],
    );
  }

  void _cancelDialog(BuildContext context) {
    Navigator.pop(context);
  }

  void _acceptDialog(BuildContext context) {
    if (_key.currentState!.validate()) {
      context.read<Ao3Model>().username = _usernameTextEditingController.text;
    }
    Navigator.pop(context);
  }
}
