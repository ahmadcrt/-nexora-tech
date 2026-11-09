import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/notice.dart';
import '../application/admin_auth_controller.dart';

class AdminSignInView extends ConsumerStatefulWidget {
  const AdminSignInView({super.key, this.message});

  final String? message;

  @override
  ConsumerState<AdminSignInView> createState() => _AdminSignInViewState();
}

class _AdminSignInViewState extends ConsumerState<AdminSignInView> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    await ref.read(adminAuthProvider.notifier).signIn(
          email: _email.text,
          password: _password.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: AutofillGroup(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.message != null) ...[
                  Notice(
                    icon: Icons.error_outline,
                    title: widget.message!,
                  ),
                  const SizedBox(height: 16),
                ],
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.username],
                  validator: (value) => (value ?? '').trim().isEmpty
                      ? 'Enter your email address.'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _password,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  onFieldSubmitted: (_) => _submit(),
                  validator: (value) =>
                      (value ?? '').isEmpty ? 'Enter your password.' : null,
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: PrimaryButton(label: 'Sign in', onPressed: _submit),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
