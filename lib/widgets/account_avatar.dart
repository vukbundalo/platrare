import 'package:flutter/material.dart';

import '../models/account.dart';
import '../utils/account_display.dart';

/// Circular or rounded-square avatar: custom icon, or first letter of name.
class AccountAvatar extends StatelessWidget {
  final Account account;
  final double size;
  final double borderRadius;

  const AccountAvatar({
    super.key,
    required this.account,
    this.size = 44,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final colors = accountAvatarColors(account, cs);
    final icon = accountIconOrNull(account);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: icon != null
            ? Icon(
                icon,
                size: size * 0.48,
                color: colors.foreground,
              )
            : Text(
                accountAvatarLetter(account),
                style: TextStyle(
                  color: colors.foreground,
                  fontWeight: FontWeight.w800,
                  fontSize: size * 0.39,
                ),
              ),
      ),
    );
  }
}
