import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../data/security_prefs.dart';
import '../l10n/app_localizations.dart';

class AppLockGate extends StatefulWidget {
  const AppLockGate({super.key, required this.child});

  final Widget child;

  @override
  State<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends State<AppLockGate> with WidgetsBindingObserver {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final TextEditingController _pinController = TextEditingController();

  bool _isUnlocked = false;
  bool _isAuthenticating = false;
  bool _supportsBiometric = false;
  bool _pinAvailable = false;
  bool _allowAutoBiometric = true;
  String? _pinError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _prepare();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pinController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!appSecurityEnabled.value) return;
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _isUnlocked = false;
      _allowAutoBiometric = true;
      if (mounted) setState(() {});
    }
    if (state == AppLifecycleState.resumed &&
        !_isUnlocked &&
        _allowAutoBiometric) {
      _tryBiometricAuth();
    }
  }

  Future<void> _prepare() async {
    _supportsBiometric = await _localAuth.isDeviceSupported();
    _pinAvailable = await hasSecurityPin();
    await _evaluateLockState();
  }

  Future<void> _evaluateLockState() async {
    if (!appSecurityEnabled.value) {
      _isUnlocked = true;
      if (mounted) setState(() {});
      return;
    }
    if (_supportsBiometric) {
      await _tryBiometricAuth();
      return;
    }
    _isUnlocked = false;
    if (mounted) setState(() {});
  }

  Future<void> _tryBiometricAuth() async {
    if (!appSecurityEnabled.value || _isAuthenticating || !mounted) return;
    final l10n = AppLocalizations.of(context);
    _isAuthenticating = true;
    try {
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: l10n.securityBiometricReason,
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: false,
        ),
      );
      if (!mounted) return;
      _isUnlocked = didAuthenticate;
      if (!didAuthenticate) {
        // Stop auto-retrying biometrics until user explicitly taps retry.
        _allowAutoBiometric = false;
      }
      _pinError = null;
      setState(() {});
    } on PlatformException {
      if (!mounted) return;
      _isUnlocked = false;
      _allowAutoBiometric = false;
      setState(() {});
    } finally {
      _isAuthenticating = false;
    }
  }

  Future<void> _unlockWithPin() async {
    final l10n = AppLocalizations.of(context);
    final pin = _pinController.text.trim();
    if (pin.length < 4) {
      setState(() => _pinError = l10n.securityPinMustBe4Digits);
      return;
    }
    final ok = await verifySecurityPin(pin);
    if (!mounted) return;
    if (ok) {
      _pinController.clear();
      setState(() {
        _isUnlocked = true;
        _pinError = null;
      });
      return;
    }
    setState(() => _pinError = l10n.securityPinIncorrect);
  }

  @override
  Widget build(BuildContext context) {
    if (_isUnlocked || !appSecurityEnabled.value) {
      return widget.child;
    }

    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      container: true,
      label: '${l10n.securityUnlockTitle}. ${l10n.securityUnlockSubtitle}',
      child: Scaffold(
        backgroundColor: cs.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock_rounded, size: 46, color: cs.primary),
                        const SizedBox(height: 12),
                        Text(
                          l10n.securityUnlockTitle,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.securityUnlockSubtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: cs.onSurfaceVariant),
                        ),
                        if (_pinAvailable) ...[
                          const SizedBox(height: 18),
                          TextField(
                            controller: _pinController,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            maxLength: 8,
                            decoration: InputDecoration(
                              labelText: l10n.securityPinLabel,
                              errorText: _pinError,
                              counterText: '',
                            ),
                            onSubmitted: (_) => _unlockWithPin(),
                          ),
                          const SizedBox(height: 10),
                          FilledButton(
                            onPressed: _unlockWithPin,
                            child: Text(l10n.securityUnlockWithPin),
                          ),
                        ],
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: _supportsBiometric
                              ? () {
                                  _allowAutoBiometric = true;
                                  _tryBiometricAuth();
                                }
                              : null,
                          icon: const Icon(Icons.fingerprint_rounded),
                          label: Text(l10n.securityTryBiometric),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
