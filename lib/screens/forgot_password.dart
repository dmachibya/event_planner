import 'package:flutter/material.dart';

import '../utils/authentication.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final email = TextEditingController();
  // final emailFocus = useFocusNode();
  final password = TextEditingController();

  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  // final passwordFocus = useFocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Forgot your password?")),
        body: Padding(
            padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Form(
                key: formKey2,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Write your email to receive reset instructions",
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: Colors.black),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        autofocus: true,
                        maxLines: 1,
                        controller: emailController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          label: Text("Email Address"),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter email";
                          }

                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                          style: ButtonStyle(),
                          onPressed: () {
                            if (formKey2.currentState!.validate()) {
                              AuthenticationHelper()
                                  .resetPassword(
                                      email: emailController.text
                                          .replaceAll(" ", ""))
                                  .then((value) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text(
                                      "Check your email for instructions."),
                                ));
                              }).onError((error, stackTrace) {
                                Navigator.pop(context);

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text("There was an error"),
                                ));
                              });
                            }
                          },
                          child: Text("Send Recovery Link"))
                    ]))));
  }
}
