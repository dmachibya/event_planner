import 'package:flutter/material.dart';
import 'package:event_planner/utils/authentication.dart';
import 'package:event_planner/utils/constants.dart';
import 'package:go_router/go_router.dart';
import 'successful_screen.dart';

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
    return Container(
      height: 55,
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: Colors.blueGrey.shade200,
          borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, top: 15, right: 25),
        child: TextField(
          controller: userInput,
          autocorrect: false,
          enableSuggestions: false,
          autofocus: false,
          decoration: InputDecoration.collapsed(
            hintText: hintTitle,
            hintStyle: TextStyle(
                fontSize: 18,
                color: Colors.white70,
                fontStyle: FontStyle.italic),
          ),
          keyboardType: keyboardType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
              image: AssetImage(
                'images/bg.jpg',
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 510,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 45),
                      userInput(
                          emailController, 'Email', TextInputType.emailAddress),
                      userInput(passwordController, 'Password',
                          TextInputType.visiblePassword),
                      Container(
                        height: 55,
                        // for an exact replicate, remove the padding.
                        // pour une réplique exact, enlever le padding.
                        padding:
                            const EdgeInsets.only(top: 5, left: 70, right: 70),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          color: Colors.indigo.shade800,
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
                                        content: Text(value,
                                            style: TextStyle(fontSize: 16)),
                                        duration: Duration(seconds: 5),
                                      ));
                                    }
                                  }).onError((error, stackTrace) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          "Tatizo limejitokeza, jaribu tena",
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
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text('Forgot password ?'),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          GoRouter.of(context).go(registerRoute);
                        },
                        child: Center(
                          child: Text.rich(
                            TextSpan(text: 'Not Registered ? ', children: [
                              TextSpan(
                                  text: "Register",
                                  style:
                                      TextStyle(color: Colors.indigo.shade800))
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
