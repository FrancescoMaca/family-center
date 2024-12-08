import 'package:family_center/extensions/string_ext.dart';
import 'package:family_center/models/family_user.dart';
import 'package:family_center/services/family_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:quickalert/quickalert.dart';

class FamilyUserEntry extends StatefulWidget {
  final FamilyUser user;
  final bool isOwner;
  final bool isMod;
  final FamilyRole currentUserRole;
  
  const FamilyUserEntry({
    super.key,
    required this.user,
    required this.isOwner,
    required this.isMod,
    required this.currentUserRole
  });

  @override
  State<FamilyUserEntry> createState() => _FamilyUserEntryState();
}

class _FamilyUserEntryState extends State<FamilyUserEntry> {
  bool get _currentUserIsMe => widget.user.id == FirebaseAuth.instance.currentUser!.uid;

  bool _canRemoveUser(FamilyRole targetUserRole) {
    if (_currentUserIsMe) {
      return false;
    }

    return widget.currentUserRole.index > targetUserRole.index;
  }

  @override
  Widget build(BuildContext context) {
    final targetUserRole = getUserRole();

    return Slidable(
      key: ValueKey(widget.key),
      startActionPane: _canRemoveUser(targetUserRole) ? ActionPane(
        extentRatio: 0.35,
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (e) {
              // Implement remove logic here
            },
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Remove',
          )
        ]
      ) : null,
      endActionPane: ActionPane(
        extentRatio: 0.35,
        motion: const DrawerMotion(),
        dragDismissible: false,
        children: [
          SlidableAction(
            onPressed: (e) => _buildFamilyMemberInfoDialog(),
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
        trailing: _buildRoleChip(targetUserRole),
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
            style: Theme.of(context).textTheme.bodySmall,
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

  void _buildFamilyMemberInfoDialog() {
    final targetUserRole = getUserRole();

    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      showConfirmBtn: false,
      title: "Information",
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: ${widget.user.name}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.black
          )),
          const SizedBox(height: 10),
          Text('Age: ${widget.user.age}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.black
          )),
          const SizedBox(height: 10),
          Text('Role: ${targetUserRole.name.capitalize()}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.black
          )),
          const SizedBox(height: 20),
          if (_canRemoveUser(targetUserRole))
            ElevatedButton(
              onPressed: () {
                // Implement kick logic here
              },
              style: const ButtonStyle(
                side: WidgetStatePropertyAll(
                  BorderSide(
                    color: Colors.redAccent,
                    width: 1
                  )
                ),
                backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                foregroundColor: WidgetStatePropertyAll(Colors.redAccent),
              ),
              child: const Text('Kick'),
            )
        ],
      ),
    );
  }
}