import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_providers.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  Timer? _checkTimer;
  bool _isResending = false;
  bool _isChecking = false;
  int _resendCooldown = 0;
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    // Periodically check if the user has verified their email
    _checkTimer = Timer.periodic(const Duration(seconds: 5), (_) => _checkVerification());
  }

  @override
  void dispose() {
    _checkTimer?.cancel();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkVerification() async {
    final authService = ref.read(authServiceProvider);
    await authService.reloadUser();
    if (authService.isEmailVerified && mounted) {
      // Manually notify the router by updating the provider
      ref.read(emailVerifiedProvider.notifier).state = true;
      // GoRouter redirect will handle navigation automatically
    }
  }

  Future<void> _manualCheck() async {
    setState(() => _isChecking = true);
    await _checkVerification();
    if (mounted) setState(() => _isChecking = false);
  }

  Future<void> _resendEmail() async {
    if (_resendCooldown > 0) return;
    setState(() => _isResending = true);
    try {
      await ref.read(authServiceProvider).resendVerificationEmail();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification email sent!'),
            backgroundColor: Colors.green,
          ),
        );
        // Start 60-second cooldown to prevent spam
        setState(() => _resendCooldown = 60);
        _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
          if (_resendCooldown <= 1) {
            t.cancel();
            if (mounted) setState(() => _resendCooldown = 0);
          } else {
            if (mounted) setState(() => _resendCooldown--);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.mark_email_unread_outlined, size: 50, color: Color(0xFF2563EB)),
              ),
              const SizedBox(height: 28),
              const Text(
                'Check your inbox',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Text(
                'We sent a verification link to\n${user?.email ?? 'your email address'}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please click the link in the email to verify your account before continuing.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.black38),
              ),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: _isChecking
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.refresh_rounded),
                  label: const Text("I've verified my email", style: TextStyle(fontWeight: FontWeight.w700)),
                  onPressed: _isChecking ? null : _manualCheck,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextButton(
                onPressed: _resendCooldown > 0 || _isResending ? null : _resendEmail,
                child: Text(
                  _resendCooldown > 0
                      ? 'Resend email in ${_resendCooldown}s'
                      : 'Resend verification email',
                  style: TextStyle(
                    color: _resendCooldown > 0 ? Colors.black38 : const Color(0xFF2563EB),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.read(authServiceProvider).signOut(),
                child: const Text('Use a different account', style: TextStyle(color: Colors.black45)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
