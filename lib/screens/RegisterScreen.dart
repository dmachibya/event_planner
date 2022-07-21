import 'package:flutter/material.dart';
import 'package:event_planner/utils/authentication.dart';
import 'package:event_planner/utils/constants.dart';
import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import '../Models/auth.dart';
import 'successful_screen.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const routeName = '/signup-screen';

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isButtonPressed = false;

  Widget signUpWith(IconData icon) {
    return Container(
      height: 50,
      width: 115,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24),
          TextButton(onPressed: () {}, child: Text('Sign in')),
        ],
      ),
    );
  }

  Widget userInput(TextEditingController userInput, String hintTitle,
      TextInputType keyboardType) {
    return TextField(
      controller: userInput,
      autocorrect: false,
      enableSuggestions: false,
      autofocus: false,
      decoration: InputDecoration(
        label: Text(hintTitle),
        border: OutlineInputBorder(),
        hintStyle: TextStyle(
            fontSize: 18, color: Colors.white70, fontStyle: FontStyle.italic),
      ),
      keyboardType: keyboardType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 20),
              Text(
                "WARMA",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                "Login",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              userInput(nameController, 'Name', TextInputType.text),
              userInput(phoneController, 'Phone', TextInputType.text),
              userInput(emailController, 'Email', TextInputType.emailAddress),
              userInput(passwordController, 'Password',
                  TextInputType.visiblePassword),
              Container(
                height: 55,
                // for an exact replicate, remove the padding.
                // pour une réplique exact, enlever le padding.
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50)),
                  onPressed: !isButtonPressed
                      ? () {
                          setState(() {
                            isButtonPressed = true;
                          });
                          AuthenticationHelper()
                              .signUp(
                                  phone: phoneController.text,
                                  role: 'normal',
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text)
                              .then((value) {
                            setState(() {
                              isButtonPressed = true;
                            });
                            if (value == null) {
                              GoRouter.of(context).go(homeRoute);
                            } else {
                              setState(() {
                                isButtonPressed = false;
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    Text(value, style: TextStyle(fontSize: 16)),
                                duration: Duration(seconds: 5),
                              ));
                            }
                          }).onError((error, stackTrace) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("There was an error",
                                    style: TextStyle(fontSize: 16)),
                                duration: Duration(seconds: 5)));
                            setState(() {
                              isButtonPressed = false;
                            });
                          });
                        }
                      : null,
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  GoRouter.of(context).go("/login");
                },
                child: Center(
                  child: Text.rich(
                    TextSpan(text: 'Already Registered ? ', children: [
                      TextSpan(
                          text: "Login",
                          style: TextStyle(color: Colors.indigo.shade800))
                    ]),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Divider(thickness: 0, color: Colors.white),
              /*
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Text('Don\'t have an account yet ? ', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),),
                      TextButton(
                      onPressed: () {},
                      child: Text(
                        'Sign Up',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    ],
                  ),
                    */
            ],
          ),
        );
      }),
    );
  }
}
