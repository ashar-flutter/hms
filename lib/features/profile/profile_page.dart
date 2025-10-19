import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hr_flow/core/shared_widgets/custom_btn.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/services/credential_store_service.dart';
import '../../core/shared_widgets/custom_field.dart';
import '../../core/services/profile_service.dart';
import '../../core/services/image_picker_service.dart';
import '../../core/snackbar/custom_snackbar.dart';
import '../dashboard/main_dashboard.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameCtr = TextEditingController();
  final lastCtr = TextEditingController();
  final emailCtr = TextEditingController();
  final roleCtr = TextEditingController();
  final profileService = ProfileService();
  final imageService = ImagePickerService();
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadSavedImage();
  }

  Future<void> _loadSavedImage() async {
    final img = await imageService.loadSavedImage();
    if (!mounted) return;
    if (img != null) {
      setState(() => _profileImage = img);
    }
  }

  Future<void> _pickImage() async {
    final img = await imageService.pickImageFromGallery();
    if (!mounted) return;
    if (img != null) {
      setState(() => _profileImage = img);
      CustomSnackBar.show(
        title: "Success",
        message: "Profile picture updated successfully",
        backgroundColor: const Color.fromARGB(255, 0, 122, 255),
        textColor: Colors.black,
        shadowColor: Colors.lightBlueAccent,
        borderColor: Colors.transparent,
        icon: Iconsax.message_tick,
      );
    }
  }

  Future<void> _deleteImage() async {
    await imageService.clearImage();
    if (!mounted) return;
    setState(() => _profileImage = null);
    CustomSnackBar.show(
      title: "Deleted",
      message: "Profile picture removed successfully",
      backgroundColor: Colors.redAccent.shade400,
      textColor: Colors.black,
      shadowColor: Colors.transparent,
      borderColor: Colors.transparent,
      icon: Iconsax.close_square,
    );
  }

  @override
  void dispose() {
    nameCtr.dispose();
    lastCtr.dispose();
    emailCtr.dispose();
    roleCtr.dispose();
    super.dispose();
  }

  Future<void> _showEditDialog() async {
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    await _pickImage();
                    if (!mounted) return;
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade100,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(46),
                          offset: const Offset(0, 6),
                          blurRadius: 18,
                        ),
                      ],
                      image: _profileImage != null
                          ? DecorationImage(
                              image: FileImage(_profileImage!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _profileImage == null
                        ? Icon(
                            Iconsax.camera,
                            size: 48,
                            color: Colors.grey.shade700,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        await _pickImage();
                        if (!mounted) return;
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Iconsax.camera),
                      label: const Text("Change"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await _deleteImage();
                        if (!mounted) return;
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Iconsax.trash),
                      label: const Text("Delete"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onContinue() async {
    final name = nameCtr.text.trim();
    final last = lastCtr.text.trim();
    final role = roleCtr.text.trim();

    final valid = await profileService.validation(
      context: context,
      name: name,
      lastName: last,
      role: role,
    );

    if (!valid) return;

    if (_profileImage == null) {
      CustomSnackBar.show(
        title: "Error",
        message: "Please upload your profile picture",
        backgroundColor: Colors.redAccent.shade400,
        textColor: Colors.black,
        shadowColor: Colors.transparent,
        borderColor: Colors.transparent,
        icon: Iconsax.close_square,
      );
      return;
    }

    CustomSnackBar.show(
      title: "Success",
      message: "Profile setup completed successfully",
      backgroundColor: const Color.fromARGB(255, 0, 122, 255),
      textColor: Colors.black,
      shadowColor: Colors.lightBlueAccent,
      borderColor: Colors.transparent,
      icon: Iconsax.message_tick,
    );

    await SecureStorageService.saveProfileCompleted(true);

    if (!mounted) return;
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MainDashboard(
          firstname: name,
          lastname: last,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Positioned.fill(
              top: AppBar().preferredSize.height * 3 + 60,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "First Name",
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    CustomField(
                      controller: nameCtr,
                      hintText: "enter your first name",
                      prefix: Icon(
                        Iconsax.user,
                        color: Colors.deepPurple.shade700,
                        size: 26,
                      ),
                      isPassword: false,
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Last Name",
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    CustomField(
                      controller: lastCtr,
                      hintText: "enter your last name",
                      prefix: Icon(
                        Iconsax.user_tag,
                        color: Colors.deepPurple.shade700,
                        size: 26,
                      ),
                      isPassword: false,
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Role",
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(35),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(38),
                              offset: const Offset(0, 5),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: DropdownButtonFormField<String>(
                          value: roleCtr.text.isEmpty ? null : roleCtr.text,
                          hint: Text(
                            "select role",
                            style: TextStyle(
                              fontFamily: "poppins",
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          items: <String>['admin', 'employee']
                              .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      fontFamily: "poppins",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              })
                              .toList(),
                          onChanged: (String? newValue) {
                            roleCtr.text = newValue ?? '';
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          dropdownColor: Colors.white,
                          icon: const Icon(Iconsax.arrow_down_1),
                        ),
                      ),
                    ),
                    SizedBox(height: AppBar().preferredSize.height / 2),
                    CustomBtn(text: "Continue", onPressed: _onContinue),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            Positioned(
              top: AppBar().preferredSize.height,
              left: 0,
              right: 0,
              child: Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(64),
                            offset: const Offset(0, 8),
                            blurRadius: 20,
                          ),
                        ],
                        image: _profileImage != null
                            ? DecorationImage(
                                image: FileImage(_profileImage!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _profileImage == null
                          ? Icon(
                              Iconsax.user,
                              color: Colors.grey.shade700,
                              size: 60,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: -5,
                      right: -5,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {
                            if (_profileImage == null) {
                              _pickImage();
                            } else {
                              _showEditDialog();
                            }
                          },
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: const Color(0xFF0D0D0D),
                            child: Icon(
                              _profileImage == null
                                  ? Iconsax.camera
                                  : Iconsax.edit,
                              color: const Color(0xFFFF3B30),
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
