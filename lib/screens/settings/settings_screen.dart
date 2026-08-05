import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/common/app_back_button.dart';
import '../../widgets/common/language_bottom_sheet.dart';
import '../../widgets/common/theme_bottom_sheet.dart';
import '../../l10n/app_localizations.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 18, 4, 8),
      child: Text(
        text,
        style: AppText.label.copyWith(
          color: AppColors.of(context).muted,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  Widget _notificationSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.ink.withOpacity(0.035),
        ),
      ),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        secondary: Icon(
          icon,
          color: AppColors.brand,
        ),
        title: Text(
          title,
          style: AppText.body.copyWith(
            color: colors.ink,
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        value: value,
        activeColor: AppColors.brand,
        onChanged: onChanged,
      ),
    );
  }

  Widget _themeTile(AppLocalizations l10n) {
    final colors = AppColors.of(context);
    final themeMode = ref.watch(themeModeProvider);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.ink.withOpacity(0.035),
        ),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.palette_outlined,
          color: AppColors.brand,
        ),
        title: Text(
          l10n.theme,
          style: AppText.body.copyWith(
            color: colors.ink,
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          _themeName(themeMode, l10n),
          style: AppText.label.copyWith(
            color: colors.muted,
            fontSize: 11,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: colors.muted,
        ),
        onTap: () => _showThemePicker(l10n),
      ),
    );
  }

 Future<void> _showThemePicker(
  AppLocalizations l10n,
) async {
  final currentTheme = ref.read(themeModeProvider);
  await ThemeBottomSheet.show(
    context: context,
    selectedTheme: currentTheme,
    onSelected: (theme) {
      ref
          .read(themeModeProvider.notifier)
          .setTheme(theme);
    },
  );
}

  String _themeName(
    ThemeMode mode,
    AppLocalizations l10n,
  ) {
    switch (mode) {
      case ThemeMode.light:
        return l10n.light;

      case ThemeMode.dark:
        return l10n.dark;

      case ThemeMode.system:
        return l10n.system;
    }
  }

  Future<void> _showLanguagePicker(
    AppLocalizations l10n,
  ) async {
    final currentLocale = ref.read(localeProvider);
    await LanguageBottomSheet.show(
      context: context,
      selectedLanguage: currentLocale.languageCode,
      languages: supportedLanguages,
      onSelected: (language) {
        ref.read(localeProvider.notifier).setLocale(language);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final locale = ref.watch(localeProvider);

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ------------------------------------------------
            // HEADER
            // ------------------------------------------------

            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  const AppBackButton(),
                  const SizedBox(width: 12),
                  Text(
                    l10n.settings,
                    style: AppText.heading.copyWith(
                      color: colors.ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

            // ------------------------------------------------
            // CONTENT
            // ------------------------------------------------

            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  30,
                ),
                children: [
                  // ==========================================
                  // NOTIFICATIONS
                  // ==========================================

                  _sectionLabel(
                    l10n.notifications,
                  ),

                  _notificationSwitchTile(
                    icon: Icons.notifications_none_rounded,
                    title: l10n.pushNotifications,
                    value: _pushNotifications,
                    onChanged: (value) {
                      setState(() {
                        _pushNotifications = value;
                      });
                    },
                  ),

                  const SizedBox(height: 10),

                  _notificationSwitchTile(
                    icon: Icons.email_outlined,
                    title: l10n.emailNotifications,
                    value: _emailNotifications,
                    onChanged: (value) {
                      setState(() {
                        _emailNotifications = value;
                      });
                    },
                  ),

                  // ==========================================
                  // APPEARANCE
                  // ==========================================

                  _sectionLabel(
                    l10n.appearance,
                  ),

                  // Theme
                  _themeTile(l10n),

                  const SizedBox(height: 10),

                  // Language
                  Container(
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colors.ink.withOpacity(0.035),
                      ),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.language_rounded,
                        color: AppColors.brand,
                      ),
                      title: Text(
                        l10n.language,
                        style: AppText.body.copyWith(
                          color: colors.ink,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        supportedLanguages[locale.languageCode] ?? 'English',
                        style: AppText.label.copyWith(
                          color: colors.muted,
                          fontSize: 11,
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: colors.muted,
                      ),
                      onTap: () {
                        _showLanguagePicker(l10n);
                      },
                    ),
                  ),

                  // ==========================================
                  // ACCOUNT
                  // ==========================================

                  _sectionLabel(
                    l10n.account,
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colors.ink.withOpacity(0.035),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Change password
                        ListTile(
                          leading: const Icon(
                            Icons.lock_outline_rounded,
                            color: AppColors.brand,
                          ),
                          title: Text(
                            l10n.changePassword,
                            style: AppText.body.copyWith(
                              color: colors.ink,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: colors.muted,
                          ),
                          onTap: () {},
                        ),

                        Divider(
                          height: 0.5,
                          color: colors.ink.withOpacity(
                            0.06,
                          ),
                        ),

                        // Delete account
                        ListTile(
                          leading: const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.redAccent,
                          ),
                          title: Text(
                            l10n.deleteAccount,
                            style: AppText.body.copyWith(
                              color: Colors.redAccent,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
