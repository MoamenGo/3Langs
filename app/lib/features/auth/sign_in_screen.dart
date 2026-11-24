import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../core/bidi.dart';

/// Email + password sign-in with Supabase Auth (free tier). Signing in is
/// optional: it only turns on sync between phone and browser.
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _message;

  Future<void> _run(Future<void> Function(GoTrueClient auth) action) async {
    final client = ref.read(supabaseProvider);
    if (client == null) return;
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      await action(client.auth);
      if (client.auth.currentUser != null && mounted) context.pop();
    } on AuthException catch (e) {
      setState(() => _message = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: BidiText(l.signIn)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(24),
            children: [
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                decoration: InputDecoration(labelText: l.email),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _password,
                obscureText: true,
                autofillHints: const [AutofillHints.password],
                decoration: InputDecoration(labelText: l.password),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _busy
                    ? null
                    : () => _run(
                        (auth) => auth.signInWithPassword(
                          email: _email.text.trim(),
                          password: _password.text,
                        ),
                      ),
                child: BidiText(l.signIn),
              ),
              TextButton(
                onPressed: _busy
                    ? null
                    : () => _run((auth) async {
                        final res = await auth.signUp(
                          email: _email.text.trim(),
                          password: _password.text,
                        );
                        if (res.session == null) {
                          setState(() => _message = l.checkEmail);
                        }
                      }),
                child: BidiText(l.createAccount),
              ),
              if (_message != null)
                BidiText(_message!, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
