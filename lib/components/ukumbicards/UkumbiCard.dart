import 'package:event_planner/models/Ukumbi.dart';
import 'package:flutter/material.dart';


class UkumbiCard extends StatelessWidget {
  final Ukumbi ukumbi;
  const UkumbiCard({Key? key,required this.ukumbi}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(ukumbi.name),
    );
  }
}