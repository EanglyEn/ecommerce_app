import 'package:flutter/material.dart';

import '../theme.dart';

void showHelpCenterSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.92,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.of(context).surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.of(context).line,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Help Center',
                            style: AppText.heading.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.of(context).ink,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      children: [
                        _sectionTitle(context, 'Contact us'),
                        _infoRow(context, Icons.mail_outline_rounded, 'Email',
                            'support@ecommerceapp.com'),
                        const SizedBox(height: 8),
                        _infoRow(context, Icons.phone_outlined, 'Phone',
                            '+855 12 345 678'),
                        const SizedBox(height: 8),
                        _infoRow(context, Icons.access_time_rounded, 'Hours',
                            'Mon–Sat, 8:00 AM – 6:00 PM'),

                        _sectionTitle(context, 'Frequently asked questions'),
                        _faqItem(
                          context,
                          'How do I track my order?',
                          'Go to My Orders from your account, tap the order and check its current status.',
                        ),
                        _faqItem(
                          context,
                          'What is your return policy?',
                          'Items can be returned within 7 days of delivery if unused and in original packaging.',
                        ),
                        _faqItem(
                          context,
                          'How do I change my delivery address?',
                          'Open Addresses under your account and add or edit an address before checkout.',
                        ),
                        _faqItem(
                          context,
                          'What payment methods are accepted?',
                          'We accept major cards and cash on delivery, shown at checkout.',
                        ),

                        _sectionTitle(context, 'App'),
                        _infoRow(context, Icons.info_outline_rounded, 'Version',
                            '1.0.0'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

Widget _sectionTitle(BuildContext context, String text) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(2, 18, 2, 10),
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

Widget _infoRow(BuildContext context, IconData icon, String label, String value) {
  return Row(
    children: [
      Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.brand.withOpacity(0.10),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Icon(icon, color: AppColors.brand, size: 18),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppText.label.copyWith(
                color: AppColors.of(context).muted,
                fontSize: 10.5,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              value,
              style: AppText.body.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.of(context).ink,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _faqItem(BuildContext context, String question, String answer) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: AppText.body.copyWith(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: AppColors.of(context).ink,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          answer,
          style: AppText.body.copyWith(
            fontSize: 12.5,
            color: AppColors.of(context).muted,
            height: 1.4,
          ),
        ),
      ],
    ),
  );
}