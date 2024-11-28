

import 'package:family_center/models/family.dart';
import 'package:family_center/services/family_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FamilyEntry extends StatefulWidget {
  final Family family;

  const FamilyEntry({super.key, required this.family});

  @override
  State<FamilyEntry> createState() => _FamilyEntryState();
}

class _FamilyEntryState extends State<FamilyEntry> {
  final FamilyService familyService = FamilyService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.family.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                widget.family.joinCode,
                style: Theme.of(context).textTheme.bodySmall
              ),
            ]
          ),
          IconButton(
            onPressed: () async {
              try {
                final String userId = FirebaseAuth.instance.currentUser!.uid;
                await familyService.leaveFamily(widget.family.joinCode, userId);
              }
              catch(e) {
                rethrow;
              }
            },
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).primaryIconTheme.color
            ),
          )
        ],
      )
    );
  }
}