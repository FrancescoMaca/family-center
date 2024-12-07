import 'package:family_center/models/family_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class FamilyUserEntry extends StatefulWidget {

  final FamilyUser user;
  
  const FamilyUserEntry({super.key, required this.user});

  @override
  State<FamilyUserEntry> createState() => _FamilyUserEntryState();
}

class _FamilyUserEntryState extends State<FamilyUserEntry> {

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(widget.key),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        dismissible: DismissiblePane(
          onDismissed: () {
            print('deleted');
          },
          confirmDismiss: () async {
            return false;
          },
        ),
        children: [
          SlidableAction(
            onPressed: (e) => print('ACTION DELETE'),
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Remove',
          )
        ]
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        dragDismissible: false,
        children: [
          SlidableAction(
            onPressed: (e) => print('ACTION SHARE'),
            backgroundColor: Theme.of(context).highlightColor,
            foregroundColor: Colors.white,
            icon: Icons.info,
            label: 'Infos',
          ),
        ]
      ),
      child: ListTile(
        title: Text(
          widget.user.name,
          style: Theme.of(context).textTheme.bodyMedium
        )
      )
    );
  }
}