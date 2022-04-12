import 'package:flutter/material.dart';
import 'package:lawyers/utils/constants.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var size, height, width;
  var paddingRatio = 0.05;
  GlobalKey _formKey = GlobalKey();

  bool checkbox = false;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      body: Stack(children: [
        Image.asset("images/bg.jpg",
            fit: BoxFit.cover, width: width, height: height),
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.7)),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: width * paddingRatio),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Find A Lawyer",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(
                  height: 6,
                ),
                const Text(
                  "REGISTER",
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.blue,
                      fontWeight: FontWeight.w900),
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text(
                        "Full name",
                        style: TextStyle(color: Colors.white),
                      ),
                      prefixIcon:
                          Icon(Icons.person_outline, color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(64))),
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text(
                        "Phone number",
                        style: TextStyle(color: Colors.white),
                      ),
                      prefixIcon:
                          Icon(Icons.phone_outlined, color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(64))),
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text(
                        "Email",
                        style: TextStyle(color: Colors.white),
                      ),
                      prefixIcon: Icon(Icons.mail_outline, color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(64))),
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text(
                        "Password",
                        style: TextStyle(color: Colors.white),
                      ),
                      prefixIcon: Icon(Icons.key_outlined, color: Colors.white),
                      suffixIcon: Icon(
                        Icons.remove_red_eye_outlined,
                        color: Colors.white,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(64))),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Checkbox(
                          checkColor: Colors.white,
                          value: checkbox,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.0)),
                          side: MaterialStateBorderSide.resolveWith((states) =>
                              BorderSide(width: 1.0, color: Colors.white)),
                          onChanged: (change) {
                            setState(() {
                              checkbox = change!;
                            });
                          }),
                      Text(
                        "I Agree to terms of service and privacy policy",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
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
                          Navigator.pushNamed(context, registerRoute);
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
                    Navigator.pushNamed(context, loginRoute);
                  },
                  child: const Text.rich(TextSpan(
                      text: "ALready Registered? ",
                      style: TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                            text: "Login", style: TextStyle(color: Colors.blue))
                      ])),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
