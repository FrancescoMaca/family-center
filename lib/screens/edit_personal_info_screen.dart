
import 'package:flutter/material.dart';

class EditPersonalInfoScreen extends StatefulWidget {
  const EditPersonalInfoScreen({super.key});

  @override
  State<EditPersonalInfoScreen> createState() => _EditPersonalInfoScreenState();
}

class _EditPersonalInfoScreenState extends State<EditPersonalInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(  
        title: Text(
          'Personal Infos', 
          style: Theme.of(context).textTheme.titleSmall
        ),
        backgroundColor: Colors.transparent,
      ),
      body: const Column(
        children: [
          TextField(

          ),
          TextField(

          ),
        ],
      ),
    );
  }
}