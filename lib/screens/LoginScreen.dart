import 'package:flutter/material.dart';
import 'package:lawyers/utils/authentication.dart';
import 'package:lawyers/utils/constants.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var size, height, width;
  var paddingRatio = 0.05;
  GlobalKey _formKey = GlobalKey();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      body: Builder(builder: (context) {
        return Stack(children: [
          Image.asset("images/bg.jpg",
              fit: BoxFit.cover, width: width, height: height),
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.7)),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: 40, horizontal: width * paddingRatio),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Find A Lawyer",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  const Text(
                    "LOGIN",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 32,
                        color: Colors.blue,
                        fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text(
                          "Email",
                          style: TextStyle(color: Colors.white),
                        ),
                        prefixIcon:
                            Icon(Icons.mail_outline, color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(64))),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text(
                          "Password",
                          style: TextStyle(color: Colors.white),
                        ),
                        prefixIcon:
                            Icon(Icons.key_outlined, color: Colors.white),
                        suffixIcon: Icon(
                          Icons.remove_red_eye_outlined,
                          color: Colors.white,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(64))),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.blue,
                            Colors.blue.shade300,
                            //add more colors
                          ]),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                                color: Color.fromRGBO(
                                    0, 0, 0, 0.3), //shadow for button
                                blurRadius: 5) //blur radius of shadow
                          ]),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            onSurface: Colors.transparent,
                            shadowColor: Colors.transparent,
                            //make color or elevated button transparent
                          ),
                          onPressed: () {
                            AuthenticationHelper()
                                .signIn(
                                    email: emailController.text,
                                    password: passwordController.text)
                                .then((value) => {
                                      if (value == null)
                                        {
                                          Navigator.pushNamed(
                                              context, homeRoute)
                                        }
                                      else
                                        {
                                          Scaffold.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                            value,
                                            style: TextStyle(fontSize: 16),
                                          )))
                                        }
                                    });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: const EdgeInsets.only(
                              top: 18,
                              bottom: 18,
                            ),
                            child: const Text("Register"),
                          ))),
                  const SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, registerRoute);
                    },
                    child: const Text.rich(TextSpan(
                        text: "Not Registered? ",
                        style: TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                              text: "Register",
                              style: TextStyle(color: Colors.blue))
                        ])),
                  )
                ],
              ),
            ),
          )
        ]);
      }),
    );
  }
}
