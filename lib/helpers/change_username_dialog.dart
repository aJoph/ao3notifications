import 'package:ao3notifications/ao3_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsernameDialog extends StatefulWidget {
  const UsernameDialog({Key? key}) : super(key: key);

  @override
  State<UsernameDialog> createState() => _UsernameDialogState();
}

class _UsernameDialogState extends State<UsernameDialog> {
  final _formKey = GlobalKey<FormState>();
  final _usernameTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _usernameTextEditingController,
          validator: (text) {
            if (text == null || text.isEmpty || text == "") {
              return 'Please type something.';
            }
            return null;
          },
          decoration: const InputDecoration(
            label: Text("Username"),
            icon: Icon(Icons.near_me),
          ),
        ),
      ),
      actions: <TextButton>[
        TextButton(
          onPressed: () => _cancelDialog(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => _acceptDialog(context),
          child: const Text("Accept"),
        )
      ],
    );
  }

  void _acceptDialog(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // context.read<Ao3Model>().username = _usernameTextEditingController.text;
      context.read<Ao3Model>().username = _usernameTextEditingController.text;
      Future.delayed(const Duration(milliseconds: 300)).then((value) {
        // For some reason, popping the context without a delay of more than ~100 milliseconds
        // Results in Ao3Model being used after being disposed...
        // I gave up on finding the proper solution and am doing this horribleness instead.
        Navigator.pop(context);
      });
    }
  }

  void _cancelDialog(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _usernameTextEditingController.dispose();
    super.dispose();
  }
}
