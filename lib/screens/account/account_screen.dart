import 'package:flutter/material.dart';

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
  String _name = 'Eangly';
  String _location = 'Phnom Penh, Cambodia';

  final String _profileImage =
      'https://i.pravatar.cc/300?img=12';

  final String _coverImage =
      'https://images.unsplash.com/photo-1441986300917-64674bd600d8';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: AccountProfileHeader(
              name: _name,
              location: _location,
              profileImage: _profileImage,
              coverImage: _coverImage,
              orders: '12',
              wishlist: '8',
              reviews: '3',
              onEditProfile: _showEditProfile,
              onEditProfileImage: () {
                _showImageOptions(type: 'profile');
              },
              onEditCoverImage: () {
                _showImageOptions(type: 'cover');
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
                    onTap: () {},
                  ),

                  MenuTile(
                    icon: Icons.favorite_border_rounded,
                    label: 'Wishlist',
                    onTap: () {},
                  ),

                  MenuTile(
                    icon: Icons.location_on_outlined,
                    label: 'Addresses',
                    onTap: () {},
                  ),

                  MenuTile(
                    icon: Icons.payment_rounded,
                    label: 'Payment Methods',
                    onTap: () {},
                  ),

                  MenuTile(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    onTap: () {},
                  ),

                  MenuTile(
                    icon: Icons.help_outline_rounded,
                    label: 'Help Center',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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
            bottom: MediaQuery.of(sheetContext)
                .viewInsets
                .bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(
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
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.line,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 20),

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

                  TextField(
                    controller: nameController,
                    textCapitalization:
                        TextCapitalization.words,
                    decoration: const InputDecoration(
                      hintText: 'Enter your name',
                      prefixIcon: Icon(
                        Icons.person_outline_rounded,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

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

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _name =
                              nameController.text.trim().isEmpty
                                  ? 'Eangly'
                                  : nameController.text.trim();

                          _location =
                              locationController.text.trim().isEmpty
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
              color: AppColors.line,
            ),
          ),
          child: ClipOval(
            child: Image.network(
              _profileImage,
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

  void _showImageOptions({
    required String type,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  type == 'profile'
                      ? 'Change profile photo'
                      : 'Change cover photo',
                  style: AppText.heading.copyWith(
                    fontSize: 19,
                  ),
                ),

                const SizedBox(height: 18),

                ImagePickerOption(
                  icon: Icons.photo_library_outlined,
                  title: 'Choose from gallery',
                  onTap: () {
                    Navigator.pop(sheetContext);

                    // ImagePicker gallery
                  },
                ),

                ImagePickerOption(
                  icon: Icons.camera_alt_outlined,
                  title: 'Take a photo',
                  onTap: () {
                    Navigator.pop(sheetContext);

                    // ImagePicker camera
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}