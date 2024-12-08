
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_center/models/family.dart' as fc;
import 'package:family_center/models/family_user.dart';
import 'package:family_center/providers/family_provider.dart';
import 'package:family_center/services/family_service.dart';
import 'package:family_center/widgets/family/family_member_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FamilyEntry extends ConsumerStatefulWidget {
  final fc.Family family;

  const FamilyEntry({super.key, required this.family});

  @override
  ConsumerState<FamilyEntry> createState() => _FamilyEntryState();
}

class _FamilyEntryState extends ConsumerState<FamilyEntry> {
  bool isExpanded = false;

  final Map<String, Future<List<dynamic>>> _userAsyncData = {};

  @override
  void initState() {
    super.initState();

    _prefetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Theme.of(context).highlightColor.withAlpha(100),
          onTap: () => setState(() => isExpanded = !isExpanded),
          child: Padding(
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
                Row(
                  children: [
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Theme.of(context).primaryIconTheme.color
                    ),
                    IconButton(
                      onPressed: () async { },
                      icon: Icon(
                        Icons.settings,
                        color: Theme.of(context).primaryIconTheme.color
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final familyProvider = ref.read(familyServiceProvider);
                        familyProvider.leaveFamily(widget.family.joinCode);
                      },
                      icon: const Icon(
                        Icons.exit_to_app,
                        color: Colors.redAccent
                      ),
                    ),
                  ],
                )
              ],
            )
          ),
        ),
        if (isExpanded)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.family.memberIds.length,
            itemBuilder: (context, index) {
              final userId = widget.family.memberIds[index];

              return FutureBuilder(
                future: _userAsyncData[userId],
                builder: (context, snapshot) {
                  
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final userSnapshot = snapshot.data![0] as DocumentSnapshot;
                  final currentUserRoleSnapshop = snapshot.data![1] as FamilyRole;

                  if (!snapshot.hasData || userSnapshot.data() == null) {
                    return const Center(
                      child: Text('No user data found'),
                    );
                  }

                  final user = FamilyUser.fromDoc(userSnapshot);

                  return FamilyUserEntry(
                    user: user,
                    isOwner: widget.family.ownerId == user.id,
                    isMod: widget.family.moderatorsIds.contains(user.id),
                    currentUserRole: currentUserRoleSnapshop,
                  );
                },
              );
            },
          )
      ],
    );
  }

  void _prefetchUserData() async {
    final familyService = ref.read(familyServiceProvider);

    for (final userId in widget.family.memberIds) {
      _userAsyncData[userId] = Future.wait([
        FirebaseFirestore.instance.collection('users').doc(userId).get(),
        familyService.getCurrentUserRole(widget.family.id)
      ]);
    }
  }
}