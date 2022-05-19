import 'package:event_planner/utils/constants.dart';
import 'package:flutter/material.dart';

class SuccessfulScreen extends StatelessWidget {
  const SuccessfulScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
          Text(
            'Congratulation',
            style: TextStyle(fontSize: 24),
          ),
          ElevatedButton(onPressed: (){
            Navigator.pushNamed(context, ukumbiRegisterScreen);
          }, child: Text("Register Ukumbi"))
        ]),
      ),
    );
  }
}
