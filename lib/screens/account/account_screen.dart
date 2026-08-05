import 'dart:io';

import 'package:ecommerce_app/app_router.dart';
import 'package:ecommerce_app/widgets/help_center_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../../theme.dart';
import '../../widgets/account/account_profile_header.dart';
import '../../widgets/common/image_picker_option.dart';
import '../../widgets/common/menu_tile.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  String _name = 'Eangly';
  String _location = 'Phnom Penh, Cambodia';

  final String _defaultProfileImage = 'https://i.pravatar.cc/300?img=12';

  final String _coverImage =
      'https://images.unsplash.com/photo-1441986300917-64674bd600d8';

  File? _profileImageFile;
  File? _coverImageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.of(context).bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: AccountProfileHeader(
              name: _name,
              location: _location,

              // Profile image
              profileImage: _profileImageFile != null
                  ? _profileImageFile!.path
                  : _defaultProfileImage,

              // Cover image
              coverImage:
                  _coverImageFile != null ? _coverImageFile!.path : _coverImage,

              orders: '12',
              wishlist: '8',
              reviews: '3',

              onEditProfile: _showEditProfile,

              onEditProfileImage: () {
                _showImageOptions(
                  type: 'profile',
                );
              },

              onEditCoverImage: () {
                _showImageOptions(
                  type: 'cover',
                );
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              16,
              20,
              16,
              30,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  MenuTile(
                    icon: Icons.receipt_long_rounded,
                    label: 'My Orders',
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.orders);
                    },
                  ),
                  MenuTile(
                      icon: Icons.favorite_border_rounded,
                      label: 'Wishlist',
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.wishlist);
                      }),
                  MenuTile(
                    icon: Icons.location_on_outlined,
                    label: 'Addresses',
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.addresses);
                    },
                  ),
                  MenuTile(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.settings);
                    },
                  ),
                  MenuTile(
                    icon: Icons.help_outline_rounded,
                    label: 'Help Center',
                    onTap: () {
                      showHelpCenterSheet(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // EDIT PROFILE
  // ===========================================================================

  void _showEditProfile() {
    final nameController = TextEditingController(
      text: _name,
    );

    final locationController = TextEditingController(
      text: _location,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.of(context).surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              24,
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag indicator
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.of(context).line,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Header
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Edit Profile',
                          style: AppText.heading.copyWith(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(sheetContext);
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Avatar
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(sheetContext);

                      _showImageOptions(
                        type: 'profile',
                      );
                    },
                    child: _editAvatar(),
                  ),

                  const SizedBox(height: 22),

                  // Name
                  TextField(
                    controller: nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      hintText: 'Enter your name',
                      prefixIcon: Icon(
                        Icons.person_outline_rounded,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Location
                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your location',
                      prefixIcon: Icon(
                        Icons.location_on_outlined,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Save
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _name = nameController.text.trim().isEmpty
                              ? 'Eangly'
                              : nameController.text.trim();

                          _location = locationController.text.trim().isEmpty
                              ? 'Phnom Penh, Cambodia'
                              : locationController.text.trim();
                        });

                        Navigator.pop(sheetContext);
                      },
                      child: const Text(
                        'Save Changes',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // EDIT AVATAR
  // ===========================================================================

  Widget _editAvatar() {
    return Stack(
      children: [
        Container(
          width: 90,
          height: 90,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.of(context).line,
            ),
          ),
          child: ClipOval(
            child: _profileImageFile != null
                ? Image.file(
                    _profileImageFile!,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    _defaultProfileImage,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 2,
          child: Container(
            width: 30,
            height: 30,
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
              size: 14,
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // IMAGE OPTIONS
  // ===========================================================================

  void _showImageOptions({
    required String type,
  }) {
    showModalBottomSheet(
      context: context,

      // iOS-style transparent background
      backgroundColor: Colors.transparent,

      isScrollControlled: true,

      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              12,
              0,
              12,
              12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // =============================================================
                // MAIN OPTIONS
                // =============================================================

                Container(
                  decoration: BoxDecoration(
                    color: AppColors.of(context).surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          20,
                          16,
                          20,
                          12,
                        ),
                        child: Text(
                          type == 'profile'
                              ? 'Change profile photo'
                              : 'Change cover photo',
                          style: AppText.body.copyWith(
                            color: AppColors.of(context).muted,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const Divider(
                        height: 0.5,
                      ),

                      // Gallery
                      ImagePickerOption(
                        icon: CupertinoIcons.photo,
                        title: 'Choose from gallery',
                        onTap: () async {
                          Navigator.pop(sheetContext);

                          await _pickImage(
                            type: type,
                            source: ImageSource.gallery,
                          );
                        },
                      ),

                      // Camera
                      ImagePickerOption(
                        icon: CupertinoIcons.camera,
                        title: 'Take a photo',
                        showDivider: false,
                        onTap: () async {
                          Navigator.pop(sheetContext);

                          await _pickImage(
                            type: type,
                            source: ImageSource.camera,
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // =============================================================
                // CANCEL
                // =============================================================

                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    color: AppColors.of(context).surface,
                    borderRadius: BorderRadius.circular(16),
                    onPressed: () {
                      Navigator.pop(sheetContext);
                    },
                    child: Text(
                      'Cancel',
                      style: AppText.body.copyWith(
                        color: AppColors.brand,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // PICK IMAGE
  // ===========================================================================

  Future<void> _pickImage({
    required String type,
    required ImageSource source,
  }) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,

        // Good quality without making the file extremely large
        imageQuality: 85,

        // Resize large camera/gallery images
        maxWidth: 1600,
        maxHeight: 1600,
      );

      // User cancelled
      if (pickedFile == null) {
        return;
      }

      final File imageFile = File(pickedFile.path);

      if (!mounted) return;

      setState(() {
        if (type == 'profile') {
          _profileImageFile = imageFile;
        } else {
          _coverImageFile = imageFile;
        }
      });
    } catch (e) {
      debugPrint(
        'Image picker error: $e',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to select image',
          ),
        ),
      );
    }
  }
}
