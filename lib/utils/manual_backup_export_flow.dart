import 'package:flutter/material.dart';

import '../data/backup_export_reminder_prefs.dart';
import '../data/data_transfer.dart';
import '../l10n/app_localizations.dart';

/// Password / unencrypted warning / share sheet. Returns `true` if a backup
/// was shared successfully (also updates backup reminder prefs).
Future<bool> runManualBackupExportFlow({
  required BuildContext context,
  required AppLocalizations l10n,
  Rect? sharePositionOrigin,
}) async {
  if (!context.mounted) return false;

  final screenSize = MediaQuery.sizeOf(context);
  final shareOrigin = sharePositionOrigin ??
      Rect.fromCenter(
        center: Offset(screenSize.width / 2, screenSize.height - 120),
        width: 200,
        height: 56,
      );

  final choice = await showDialog<String?>(
    context: context,
    builder: (ctx) => BackupExportPasswordDialog(l10n: l10n),
  );
  if (!context.mounted || choice == null) return false;

  late final bool encrypt;
  late final String? password;
  if (choice.isEmpty) {
    final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(l10n.backupExportSkipWarningTitle),
            content: Text(l10n.backupExportSkipWarningBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l10n.backupExportSkipWarningConfirm),
              ),
            ],
          ),
        ) ??
        false;
    if (!context.mounted || !ok) return false;
    encrypt = false;
    password = null;
  } else {
    encrypt = true;
    password = choice;
  }

  if (!context.mounted) return false;
  try {
    await DataTransfer.shareBackup(
      encrypt: encrypt,
      password: password,
      sharePositionOrigin: shareOrigin,
    );
  } catch (e) {
    debugPrint('[Export] Failed: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsDataExportFailed)),
      );
    }
    return false;
  }

  await recordSuccessfulManualBackupExport();
  return true;
}

class BackupExportPasswordDialog extends StatefulWidget {
  const BackupExportPasswordDialog({super.key, required this.l10n});
  final AppLocalizations l10n;

  @override
  State<BackupExportPasswordDialog> createState() =>
      _BackupExportPasswordDialogState();
}

class _BackupExportPasswordDialogState extends State<BackupExportPasswordDialog> {
  late final TextEditingController _pwd1;
  late final TextEditingController _pwd2;
  String? _fieldError;

  AppLocalizations get l10n => widget.l10n;

  @override
  void initState() {
    super.initState();
    _pwd1 = TextEditingController();
    _pwd2 = TextEditingController();
  }

  @override
  void dispose() {
    _pwd1.dispose();
    _pwd2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(l10n.backupExportDialogTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.backupExportDialogBody),
            const SizedBox(height: 16),
            TextField(
              controller: _pwd1,
              obscureText: true,
              decoration: InputDecoration(
                labelText: l10n.backupExportPasswordLabel,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _pwd2,
              obscureText: true,
              decoration: InputDecoration(
                labelText: l10n.backupExportPasswordConfirmLabel,
                errorText: _fieldError,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, ''),
          child: Text(l10n.backupExportWithoutEncryption),
        ),
        FilledButton(
          onPressed: () {
            final a = _pwd1.text.trim();
            final b = _pwd2.text.trim();
            if (a.isEmpty || b.isEmpty) {
              setState(() => _fieldError = l10n.backupExportPasswordEmpty);
              return;
            }
            if (a.length < 8) {
              setState(() => _fieldError = l10n.backupExportPasswordTooShort);
              return;
            }
            if (a != b) {
              setState(() => _fieldError = l10n.backupExportPasswordMismatch);
              return;
            }
            setState(() => _fieldError = null);
            Navigator.pop(context, a);
          },
          child: Text(l10n.confirm),
        ),
      ],
    );
  }
}
