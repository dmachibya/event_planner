import 'package:event_planner/models/Ukumbi.dart';
import 'package:event_planner/utils/DB.dart';
import 'package:flutter/material.dart';
class UkumbiDetailScreen extends StatefulWidget {
  final Ukumbi ukumbi;
  const UkumbiDetailScreen({ Key? key,required this.ukumbi }) : super(key: key);

  @override
  State<UkumbiDetailScreen> createState() => _UkumbiDetailScreenState();
}

class _UkumbiDetailScreenState extends State<UkumbiDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text(widget.ukumbi.name)),
    );
  }
}