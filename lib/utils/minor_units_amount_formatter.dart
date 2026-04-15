import 'package:flutter/services.dart';

/// Money entry as implicit decimal places (minor units): typing `3400`
/// displays `34.00` without typing a decimal separator.
///
/// Keep one instance per [TextField] and call [syncFromDisplay] after
/// programmatic [TextEditingController.text] assignments (e.g. edit mode).
class MinorUnitsAmountInputFormatter extends TextInputFormatter {
  MinorUnitsAmountInputFormatter({this.allowNegative = false});

  final bool allowNegative;

  static const int _maxDigits = 14;

  String _digits = '';
  bool _neg = false;

  /// Rebuild internal buffer from a display string like `12.34` or `-0.50`.
  void syncFromDisplay(String display) {
    final s = display.trim().replaceAll(',', '.');
    if (s.isEmpty) {
      _digits = '';
      _neg = false;
      return;
    }
    if (allowNegative && s == '-') {
      _digits = '';
      _neg = true;
      return;
    }
    final v = double.tryParse(s);
    if (v == null) {
      _digits = '';
      _neg = false;
      return;
    }
    _neg = v < 0;
    final absMinor = (v.abs() * 100).round();
    _digits = absMinor == 0 ? '' : absMinor.toString();
  }

  String _formattedText() {
    if (_digits.isEmpty) {
      return _neg && allowNegative ? '-' : '';
    }
    final minor = int.tryParse(_digits) ?? 0;
    final mag = minor / 100.0;
    final v = _neg ? -mag : mag;
    return v.toStringAsFixed(2);
  }

  TextEditingValue _emit() {
    final t = _formattedText();
    return TextEditingValue(
      text: t,
      selection: TextSelection.collapsed(offset: t.length),
    );
  }

  void _applyFullReplace(String raw) {
    var s = raw.trim().replaceAll(' ', '').replaceAll(',', '.');
    if (s.isEmpty) {
      _digits = '';
      _neg = false;
      return;
    }
    if (allowNegative && s == '-') {
      _digits = '';
      _neg = true;
      return;
    }
    final neg = allowNegative && s.startsWith('-');
    if (neg) s = s.substring(1);

    final hasDecimalSep = s.contains('.');

    if (!hasDecimalSep) {
      final onlyDigits = s.replaceAll(RegExp(r'[^\d]'), '');
      if (onlyDigits.isEmpty) {
        _digits = '';
        _neg = neg;
        return;
      }
      _neg = neg;
      _digits = _truncateDigitRun(onlyDigits);
      return;
    }

    final v = double.tryParse(s);
    if (v == null) {
      _digits = '';
      _neg = false;
      return;
    }
    _neg = neg;
    final absMinor = (v.abs() * 100).round();
    _digits = absMinor == 0 ? '' : absMinor.toString();
  }

  String _truncateDigitRun(String d) {
    var run = d.length > _maxDigits
        ? d.substring(d.length - _maxDigits)
        : d;
    while (run.length > 1 && run.startsWith('0')) {
      run = run.substring(1);
    }
    return run;
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final o = oldValue.text.replaceAll(',', '.');
    final n = newValue.text.replaceAll(',', '.');

    if (n.isEmpty) {
      _digits = '';
      _neg = false;
      return const TextEditingValue(text: '', selection: TextSelection.collapsed(offset: 0));
    }

    if (allowNegative && n == '-' && _digits.isEmpty) {
      _neg = true;
      return const TextEditingValue(text: '-', selection: TextSelection.collapsed(offset: 1));
    }

    // Single-character delete at end of our formatted string.
    if (n.length == o.length - 1 && o.startsWith(n)) {
      if (_digits.isNotEmpty) {
        _digits = _digits.substring(0, _digits.length - 1);
      } else if (_neg) {
        _neg = false;
      }
      return _emit();
    }

    // Single character typed at end (works with formatted text like `0.00` + `1` → `0.001`).
    if (n.length == o.length + 1 && n.substring(0, n.length - 1) == o) {
      final ch = n[n.length - 1];
      if (ch == '-' && allowNegative && o.isEmpty) {
        _neg = true;
        return const TextEditingValue(text: '-', selection: TextSelection.collapsed(offset: 1));
      }
      if (RegExp(r'\d').hasMatch(ch)) {
        final next = _digits + ch;
        _digits = next.length > _maxDigits
            ? next.substring(next.length - _maxDigits)
            : next;
        return _emit();
      }
      // Ignore non-digit append (e.g. decimal key)
      return oldValue;
    }

    // Selection replace, paste, or mid-field edit — interpret as full replace.
    _applyFullReplace(n);
    return _emit();
  }
}
