import 'package:ao3notifications/models/ao3_model.dart';
import 'package:ao3notifications/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final formKey = GlobalKey<FormState>();
  final usernameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
      body: Center(
          child: Card(
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Ao3",
                      style: Theme.of(context).textTheme.headlineMedium),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: TextFormField(
                      controller: usernameTextController,
                      textInputAction: TextInputAction.done,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please type something.';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).highlightColor,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        label: const Text('Username'),
                      ),
                      keyboardType: TextInputType.name,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: ElevatedButton(
                      onPressed: () => validateUsername(context),
                      style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(const Size(200, 60)),
                      ),
                      child: const Text("Login"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }

  Future<void> validateUsername(BuildContext context) async {
    if (formKey.currentState!.validate() == false) return;

    final usernameValid =
        await Ao3Model.checkUsernameValid(usernameTextController.text);

    if (usernameValid) {
      context.read<Ao3Model>().username = usernameTextController.text;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: ((context) => const HomePage())));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text("Couldn't find username."),
            actions: <TextButton>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Ok"),
              )
            ],
          );
        },
      );
      usernameTextController.clear();
    }
  }

  @override
  void dispose() {
    usernameTextController.dispose();
    super.dispose();
  }
}
