import 'package:flutter/material.dart';
import 'package:event_planner/utils/authentication.dart';
import 'package:event_planner/utils/constants.dart';
import 'package:go_router/go_router.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const routeName = '/login-screen';

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isButtonPressed = false;

  Widget login(IconData icon) {
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
          TextButton(onPressed: () {}, child: Text('Login')),
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
      ),
      keyboardType: keyboardType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 80),
                Text(
                  "WARMA",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 20),
                Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 45),
                userInput(emailController, 'Email', TextInputType.emailAddress),
                SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  autofocus: false,
                  decoration: InputDecoration(
                    label: Text("Password"),
                    border: OutlineInputBorder(),
                    hintStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        fontStyle: FontStyle.italic),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: () {
                          GoRouter.of(context).go('/login/forgot_password');
                        },
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(color: Colors.pink),
                        ))
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50)),
                  onPressed: !isButtonPressed
                      ? () {
                          setState(() {
                            isButtonPressed = true;
                          });
                          AuthenticationHelper()
                              .signIn(
                                  email: emailController.text,
                                  password: passwordController.text)
                              .then((value) {
                            setState(() {
                              isButtonPressed = false;
                            });
                            if (value == null) {
                              GoRouter.of(context).go(homeRoute);
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    Text(value, style: TextStyle(fontSize: 16)),
                                duration: Duration(seconds: 5),
                              ));
                            }
                          }).onError((error, stackTrace) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Tatizo limejitokeza, jaribu tena",
                                  style: TextStyle(fontSize: 16)),
                              duration: Duration(seconds: 5),
                            ));
                            setState(() {
                              isButtonPressed = false;
                            });
                          });
                        }
                      : null,
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    GoRouter.of(context).go("/login/register");
                  },
                  child: Center(
                    child: Text.rich(
                      TextSpan(text: 'Not Registered ? ', children: [
                        TextSpan(
                            text: "Register",
                            style: TextStyle(color: Colors.indigo.shade800))
                      ]),
                    ),
                  ),
                ),
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
              ]),
        );
      }),
    );
  }
}
