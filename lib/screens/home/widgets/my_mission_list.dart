import 'package:flutter/material.dart';

class MyMissionList extends StatelessWidget {
  final List<String> missions;

  const MyMissionList({super.key, required this.missions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: missions.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(missions[index]));
      },
    );
  }
}
