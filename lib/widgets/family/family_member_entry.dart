import 'package:family_center/models/family_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

enum FamilyRole {
  owner,
  moderator,
  member
}

class FamilyUserEntry extends StatefulWidget {
  final FamilyUser user;
  final bool isOwner;
  final bool isMod;
  
  const FamilyUserEntry({
    super.key,
    required this.user,
    required this.isOwner,
    required this.isMod
  });

  @override
  State<FamilyUserEntry> createState() => _FamilyUserEntryState();
}

class _FamilyUserEntryState extends State<FamilyUserEntry> {

  @override
  Widget build(BuildContext context) {
    final role = getUserRole();

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
        ),
        trailing: _buildRoleChip(role),
      )
    );
  }

  Widget _buildRoleChip(FamilyRole role) {
    Color chipColor;
    String roleText;
    IconData roleIcon;

    switch (role) {
      case FamilyRole.owner:
        chipColor = Colors.amber;
        roleText = 'Owner';
        roleIcon = Icons.star;
        break;
      case FamilyRole.moderator:
        chipColor = Colors.blue;
        roleText = 'Mod';
        roleIcon = Icons.shield;
        break;
      case FamilyRole.member:
        chipColor = Colors.grey;
        roleText = 'Member';
        roleIcon = Icons.person;
        break;
    }

    return Chip(
      backgroundColor: chipColor.withOpacity(0.2),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(roleIcon, size: 16, color: chipColor),
          const SizedBox(width: 4),
          Text(
            roleText,
            style: TextStyle(color: chipColor),
          ),
        ],
      ),
    );
  }

  FamilyRole getUserRole() {
    if (widget.isOwner) {
      return FamilyRole.owner;
    }
    else if (widget.isMod) {
      return FamilyRole.moderator;
    }

    return FamilyRole.member;
  }
}