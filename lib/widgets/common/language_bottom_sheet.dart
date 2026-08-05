import 'package:flutter/material.dart';
import '../../theme.dart';

class LanguageBottomSheet extends StatefulWidget {
  final String selectedLanguage;
  final Map<String, String> languages;
  final ValueChanged<String> onSelected;

  const LanguageBottomSheet({
    super.key,
    required this.selectedLanguage,
    required this.languages,
    required this.onSelected,
  });

  static Future<void> show({
    required BuildContext context,
    required String selectedLanguage,
    required Map<String, String> languages,
    required ValueChanged<String> onSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
      isScrollControlled: true,
      builder: (context) {
        return LanguageBottomSheet(
          selectedLanguage: selectedLanguage,
          languages: languages,
          onSelected: onSelected,
        );
      },
    );
  }

  @override
  State<LanguageBottomSheet> createState() =>
      _LanguageBottomSheetState();
}

class _LanguageBottomSheetState
    extends State<LanguageBottomSheet> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();

    _selectedLanguage = widget.selectedLanguage;
  }

  void _selectLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
    });

    // Change language in the main app.
    widget.onSelected(language);

    // DON'T Navigator.pop()
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          8,
          0,
          8,
          8,
        ),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),

            // ----------------------------------------------
            // DRAG HANDLE
            // ----------------------------------------------

            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colors.muted.withOpacity(.25),
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 22),

            // ----------------------------------------------
            // HEADER
            // ----------------------------------------------

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color:
                          AppColors.brand.withOpacity(.10),
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.language_rounded,
                      color: AppColors.brand,
                      size: 23,
                    ),
                  ),

                  const SizedBox(width: 13),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Language',
                          style: AppText.heading.copyWith(
                            color: colors.ink,
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          'Choose your preferred language',
                          style: AppText.label.copyWith(
                            color: colors.muted,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ----------------------------------------------
            // LANGUAGE LIST
            // ----------------------------------------------

            ...widget.languages.entries.map(
              (entry) {
                final selected =
                    _selectedLanguage == entry.key;

                return _LanguageRow(
                  code: entry.key,
                  name: entry.value,
                  selected: selected,
                  onTap: () {
                    _selectLanguage(entry.key);
                  },
                );
              },
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// LANGUAGE ROW
// ==========================================================

class _LanguageRow extends StatelessWidget {
  final String code;
  final String name;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageRow({
    required this.code,
    required this.name,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 3,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 250,
          ),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 11,
          ),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.brand.withOpacity(.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              // ------------------------------------------
              // LANGUAGE BADGE
              // ------------------------------------------

              AnimatedContainer(
                duration: const Duration(
                  milliseconds: 250,
                ),
                curve: Curves.easeOutCubic,
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.brand
                      : colors.ink.withOpacity(.06),
                  borderRadius:
                      BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    code == 'km' ? 'ខ្មែរ' : 'EN',
                    style: AppText.label.copyWith(
                      color: selected
                          ? Colors.white
                          : colors.ink,
                      fontSize:
                          code == 'km' ? 10 : 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // ------------------------------------------
              // LANGUAGE NAME
              // ------------------------------------------

              Expanded(
                child: Text(
                  name,
                  style: AppText.body.copyWith(
                    color: colors.ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              // ------------------------------------------
              // CHECK
              // ------------------------------------------

              AnimatedSwitcher(
                duration: const Duration(
                  milliseconds: 220,
                ),
                transitionBuilder:
                    (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: selected
                    ? Container(
                        key: const ValueKey(
                          'selected',
                        ),
                        width: 28,
                        height: 28,
                        decoration:
                            const BoxDecoration(
                          color: AppColors.brand,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      )
                    : const SizedBox(
                        key: ValueKey('empty'),
                        width: 28,
                        height: 28,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
