// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../theme.dart';
import 'account_profile_stat.dart';

class AccountProfileHeader extends StatelessWidget {
  final String name;
  final String location;
  final String profileImage;
  final String coverImage;

  final String orders;
  final String wishlist;
  final String reviews;

  final VoidCallback? onEditProfile;
  final VoidCallback? onEditProfileImage;
  final VoidCallback? onEditCoverImage;

  const AccountProfileHeader({
    super.key,
    required this.name,
    required this.location,
    required this.profileImage,
    required this.coverImage,
    required this.orders,
    required this.wishlist,
    required this.reviews,
    this.onEditProfile,
    this.onEditProfileImage,
    this.onEditCoverImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCover(context),
        _buildInformation(context),
      ],
    );
  }

  Widget _buildCover(BuildContext context) {
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (coverImage.isNotEmpty)
            Image.network(
              coverImage,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return _fallbackCover();
              },
            )
          else
            _fallbackCover(),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 110,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.45),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 16,
            child: _EditProfileButton(
              onTap: onEditProfile,
            ),
          ),

          Positioned(
            right: 16,
            bottom: 14,
            child: _CoverButton(
              onTap: onEditCoverImage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformation(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          color: AppColors.of(context).surface,
          padding: const EdgeInsets.fromLTRB(
            20,
            50,
            20,
            20,
          ),
          child: Column(
            children: [
              Text(
                name,
                style: AppText.heading.copyWith(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 3),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    color: AppColors.brand,
                    size: 15,
                  ),
                  const SizedBox(width: 3),
                  Flexible(
                    child: Text(
                      location,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.body.copyWith(
                        color: AppColors.of(context).muted,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(
                    child: AccountProfileStat(
                      value: orders,
                      label: 'Orders',
                    ),
                  ),

                  _divider(context),

                  Expanded(
                    child: AccountProfileStat(
                      value: wishlist,
                      label: 'Wishlist',
                    ),
                  ),

                  _divider(context),

                  Expanded(
                    child: AccountProfileStat(
                      value: reviews,
                      label: 'Reviews',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Positioned(
          top: -40,
          left: 0,
          right: 0,
          child: Center(
            child: _Avatar(
              image: profileImage,
              onEdit: onEditProfileImage,
            ),
          ),
        ),
      ],
    );
  }

  Widget _divider(BuildContext context) {
    return Container(
      width: 1,
      height: 30,
      color: AppColors.of(context).line,
    );
  }

  Widget _fallbackCover() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.brand,
            AppColors.brandDark,
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String image;
  final VoidCallback? onEdit;

  const _Avatar({
    required this.image,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 82,
          height: 82,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipOval(
            child: image.isNotEmpty
                ? Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return _fallbackAvatar();
                    },
                  )
                : _fallbackAvatar(),
          ),
        ),

        Positioned(
          right: -2,
          bottom: 0,
          child: GestureDetector(
            onTap: onEdit,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.brand,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _fallbackAvatar() {
    return Container(
      color: AppColors.brand,
      child: const Icon(
        Icons.person_rounded,
        color: Colors.white,
        size: 38,
      ),
    );
  }
}

class _EditProfileButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _EditProfileButton({
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.30),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.white.withOpacity(0.25),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.edit_rounded,
              color: Colors.white,
              size: 17,
            ),
            const SizedBox(width: 6),
            Text(
              'Edit profile',
              style: AppText.label.copyWith(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoverButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _CoverButton({
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.30),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.25),
          ),
        ),
        child: const Icon(
          Icons.camera_alt_rounded,
          color: Colors.white,
          size: 17,
        ),
      ),
    );
  }
}