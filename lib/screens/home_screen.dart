import 'dart:async';

import 'package:family_center/providers/family_provider.dart';
import 'package:family_center/services/family_service.dart';
import 'package:family_center/themes/theme.dart';
import 'package:family_center/utils/family_code_utils.dart';
import 'package:family_center/widgets/family/family_entry.dart';
import 'package:fancy_snackbar/fancy_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:quickalert/quickalert.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState()  => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<ConsumerStatefulWidget> {
  late StreamController<ErrorAnimationType> errorController;
  late FamilyService familyService;

  @override
  void initState() {
    super.initState();

    familyService = FamilyService();
    errorController = StreamController<ErrorAnimationType>.broadcast();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final familiesAsyncValue = ref.watch(userFamiliesProvider);

    return familiesAsyncValue.when(
      data: (families) {
        if (families.isEmpty) {
          return _createNoFamilyText(context);
        }

        return ListView.builder(
          itemCount: families.length,
          itemBuilder: (context, index) {
            return FamilyEntry(family: families[index]);
          },
        );
      },
      loading: () => Center(
        child: Text(
          "Loading family members...",
          style: Theme.of(context).textTheme.bodyMedium,
        )
      ),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _createNoFamilyText(BuildContext context) {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: SvgPicture.asset(
              'assets/illustrations/void${MediaQuery.platformBrightnessOf(context) == Brightness.light ? '' : '_dark'}.svg',
              width: 200,
              height: 200,
              key: ValueKey(Theme.of(context).brightness),
            ),
          ),
          const SizedBox(height: 30),
          const Text('You are not part of any family yet', style: TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins'
          )),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => _showJoinFamilyDialog(context),
            style: Theme.of(context).elevatedButtonTheme.style,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Join a Family',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: 10),
                Icon(Icons.person_rounded, color: Theme.of(context).primaryIconTheme.color)
              ]
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _showCreateFamilyDialog(context),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
              shadowColor: const WidgetStatePropertyAll(Colors.transparent),
              side: WidgetStatePropertyAll(
                BorderSide(
                  color: Theme.of(context).primaryColor,
                )
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius)
                )
              )
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Create a Family',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: 10),
                Icon(Icons.family_restroom_rounded, color: Theme.of(context).primaryIconTheme.color)
              ]
            ),
          )
        ],
      ),
    );
  }

  void _showJoinFamilyDialog(BuildContext context) {
    final codeController = TextEditingController();

    QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      barrierDismissible: true,
      text: 'Enter the five digit codes for the family you want to join',
      textColor: Theme.of(context).primaryIconTheme.color!,
      showConfirmBtn: false,
      showCancelBtn: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      customAsset: 'assets/illustrations/family_code${MediaQuery.platformBrightnessOf(context) == Brightness.light ? '' : '_dark'}.png',
      headerBackgroundColor:Theme.of(context).primaryColor,
      widget: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
            child: PinCodeTextField(
              controller: codeController,
              beforeTextPaste: (_) => false,
              length: 6,
              autoFocus: true,
              appContext: context,
              useHapticFeedback: true,
              autoDismissKeyboard: false,
              autoUnfocus: false,
              hapticFeedbackTypes: HapticFeedbackTypes.light,
              animationType: AnimationType.scale,
              backgroundColor: Colors.transparent,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                inactiveColor: Theme.of(context).primaryColor
              ),
              keyboardType: TextInputType.number,
              keyboardAppearance: MediaQuery.platformBrightnessOf(context),
              onChanged: (code) => codeController.text = code,
              onCompleted: (code) => {
                _handleJoinFamily(codeController.text),
                Navigator.pop(context)
              },
              errorAnimationController: errorController,
            ),
          ),
          FutureBuilder(
            future: Clipboard.getData(Clipboard.kTextPlain),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }

              return ElevatedButton(
                onPressed: () {
                  if (snapshot.data == null || snapshot.data?.text == null || !isFamilyCodeValid(snapshot.data?.text)) {
                    FancySnackbar.showSnackbar(
                      context,
                      snackBarType: FancySnackBarType.warning,
                      color: SnackBarColors.warning2,
                      title: "Error",
                      messageWidget: const Text("The clipboard does not contain a valid code format."),
                      duration: 3,
                    );
                  }
                  else {
                    codeController.text = snapshot.data!.text!;
                  }
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
                  shadowColor: const WidgetStatePropertyAll(Colors.transparent),
                  side: WidgetStatePropertyAll(
                    BorderSide(
                      color: Theme.of(context).primaryColor,
                    )
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius)
                    )
                  )
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Paste code',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 10),
                    Icon(Icons.paste_rounded, color: Theme.of(context).primaryIconTheme.color)
                  ],
                )
              );
            }
          )
        ]
      )
    );
  }

  void _showCreateFamilyDialog(BuildContext context) {
    final nameController = TextEditingController();

    QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      barrierDismissible: true,
      text: 'Enter the five digit codes for the family you want to join',
      textColor: Theme.of(context).primaryIconTheme.color!,
      showConfirmBtn: false,
      showCancelBtn: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      customAsset: 'assets/illustrations/family${MediaQuery.platformBrightnessOf(context) == Brightness.light ? '' : '_dark'}.png',
      headerBackgroundColor: Theme.of(context).primaryColor,
      widget: Builder(
        builder: (context) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                child: TextField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  keyboardAppearance: MediaQuery.platformBrightnessOf(context),
                  onTapOutside: (e) => FocusScope.of(context).unfocus(),
                  onChanged: (code) => nameController.text = code,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Enter family name',
                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => {
                  _handleCreateFamily(nameController.text),
                  Navigator.pop(context)
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
                  shadowColor: const WidgetStatePropertyAll(Colors.transparent),
                  side: const WidgetStatePropertyAll(
                    BorderSide(
                      width: 0,
                    )
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius)
                    )
                  )
                ),
                child: Text(
                  'Create',
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              )
            ]
          );
        }
      )
    );
  }

  void _handleCreateFamily(String familyName) async {
    try {
      final String userId = FirebaseAuth.instance.currentUser!.uid;

      await familyService.createFamily(familyName, userId);
      
      _showAlertFamilyCreationSuccess();
    }
    catch (e) {
      _showAlertFamilyCreationFailiure(e.toString());
    }
  }

  void _handleJoinFamily(String familyCode) async {

    try {
      final String userId = FirebaseAuth.instance.currentUser!.uid;

      await familyService.requestToJoinFamily(familyCode, userId, "Franco");

      if (mounted) {
        FancySnackbar.showSnackbar(
          context,
          title: "Request sent",
          message: "You sent a request to the owner to join the family."
        );
      }
    }
    catch (e) {
      if (e.toString().contains('Family not found')) {
        _showAlertFamilyCodeFailiure('Family code was not found!');
      }
      if (e.toString().contains('Family is full')) {
        _showAlertFamilyCodeFailiure('Family is full!');
      }
    }
  }

  void _showAlertFamilyCreationSuccess() {
    FancySnackbar.showSnackbar(
      context,
      snackBarType: FancySnackBarType.success,
      color: SnackBarColors.success2,
      title: "Family created!",
      messageWidget: const SizedBox(),
      duration: 3,
    );
  }

  void _showAlertFamilyCreationFailiure(String errorMessage) {
    FancySnackbar.showSnackbar(
      context,
      snackBarType: FancySnackBarType.error,
      color: SnackBarColors.error2,
      title: "Failed to create family",
      message: errorMessage,
      duration: 3,
    );
  }

  void _showAlertFamilyCodeFailiure(String errorMessage) {
    FancySnackbar.showSnackbar(
      context,
      snackBarType: FancySnackBarType.error,
      color: SnackBarColors.error2,
      title: "Failed to join family",
      message: errorMessage,
      duration: 3,
    );
  }
}
