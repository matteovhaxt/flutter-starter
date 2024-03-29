// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../core/core.dart';
import '../features.dart';

class SignupView extends HookConsumerWidget {
  const SignupView({super.key});

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? _validateBirthdate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Birthdate is required';
    }
    return null;
  }

  Future<DateTime?> _showBirthdatePicker(BuildContext context) async {
    return await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final birthdateController = useTextEditingController();
    final userState = ref.read(userStateProvider);
    if (userState.hasError) {
      context.showSnackBar(userState.error.toString());
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card.outlined(
                clipBehavior: Clip.hardEdge,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    controller: nameController,
                    autofocus: true,
                    validator: _validateName,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                ),
              ),
              Card.outlined(
                clipBehavior: Clip.hardEdge,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    controller: birthdateController,
                    onTapAlwaysCalled: true,
                    onTap: () async {
                      final date = await _showBirthdatePicker(context);
                      if (date != null) {
                        final formatted = DateFormat("yyyy-MM-dd").format(date);
                        birthdateController.text = formatted;
                      }
                    },
                    validator: _validateBirthdate,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      labelText: 'Birthdate',
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  ref.read(userStateProvider.notifier).createUser(
                        nameController.text,
                        DateTime.parse(birthdateController.text),
                      );
                },
                child: const Text('Sign Up'),
              ),
              TextButton(
                onPressed: () {
                  ref.read(authStateProvider.notifier).signOut();
                },
                child: const Text('Sign Out'),
              )
            ].separated(
              const Gap(8),
            ),
          ),
        ),
      ),
    );
  }
}