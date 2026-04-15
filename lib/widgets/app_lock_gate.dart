import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../data/security_prefs.dart';
import '../l10n/app_localizations.dart';
import '../theme/platrare_surfaces.dart';

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
  DateTime? _wentToBackgroundAt;

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
    if (!appSecurityEnabled.value) {
      _wentToBackgroundAt = null;
      return;
    }
    if (_isTrueBackgroundState(state)) {
      _onApplicationBackgrounded();
    } else if (state == AppLifecycleState.resumed) {
      _onApplicationResumed();
    }
  }

  /// [inactive] is intentionally ignored (system UI overlays, brief interruptions).
  bool _isTrueBackgroundState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      return true;
    }
    return state == AppLifecycleState.hidden;
  }

  void _onApplicationBackgrounded() {
    final graceSec = appLockGraceSeconds.value;
    if (graceSec <= 0) {
      _isUnlocked = false;
      _allowAutoBiometric = true;
      _wentToBackgroundAt = null;
    } else {
      _wentToBackgroundAt = DateTime.now();
    }
    if (mounted) setState(() {});
  }

  void _onApplicationResumed() {
    if (!appSecurityEnabled.value) return;
    final grace = Duration(seconds: appLockGraceSeconds.value);
    if (grace == Duration.zero) {
      if (!_isUnlocked && _allowAutoBiometric) {
        _tryBiometricAuth();
      }
      return;
    }
    if (_wentToBackgroundAt == null) {
      if (!_isUnlocked && _allowAutoBiometric) {
        _tryBiometricAuth();
      }
      return;
    }
    final away = DateTime.now().difference(_wentToBackgroundAt!);
    _wentToBackgroundAt = null;
    if (away < grace) {
      if (mounted) setState(() {});
      return;
    }
    _isUnlocked = false;
    _allowAutoBiometric = true;
    if (mounted) setState(() {});
    if (!_isUnlocked && _allowAutoBiometric) {
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
    return ValueListenableBuilder<bool>(
      valueListenable: appSecurityEnabled,
      builder: (context, securityEnabled, _) {
        final showLock = securityEnabled && !_isUnlocked;
        return Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            AbsorbPointer(
              absorbing: showLock,
              child: ExcludeSemantics(
                excluding: showLock,
                child: widget.child,
              ),
            ),
            if (showLock) Positioned.fill(child: _buildLockLayer(context)),
          ],
        );
      },
    );
  }

  Widget _buildLockLayer(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;
    return Semantics(
      container: true,
      label: '${l10n.securityUnlockTitle}. ${l10n.securityUnlockSubtitle}',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: DecoratedBox(
          decoration: PlatrareSurfaces.lockBackdrop(cs, brightness),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380),
                  child: Card(
                    color: cs.surfaceContainerHigh,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: cs.primary.withValues(alpha: 0.22),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.lock_rounded, size: 46, color: cs.primary),
                          const SizedBox(height: 12),
                          Text(
                            l10n.securityUnlockTitle,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
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
      ),
    );
  }
}
