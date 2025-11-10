import 'package:flutter/material.dart';
import 'package:hr_flow/features/user/user_information/settings_page.dart';
import '../service/app_storage_service.dart';
import '../widgets/profile_content.dart';
import '../widgets/terms_overlay.dart';

class UserInformation extends StatefulWidget {
  const UserInformation({super.key});

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  bool isLoading = true;
  bool hasAcceptedTerms = false;

  @override
  void initState() {
    super.initState();
    _checkTermsStatus();
  }

  Future<void> _checkTermsStatus() async {
    final acceptedTerms = await AppStorageService.isTermsAccepted();
    if (mounted) {
      setState(() {
        hasAcceptedTerms = acceptedTerms;
        isLoading = false;
      });
    }
  }

  void _onTermsAccepted() {
    if (mounted) {
      setState(() {
        hasAcceptedTerms = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontSize: 16,
            fontFamily: "bold",
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (hasAcceptedTerms)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.black, size: 26),
              onSelected: (value) {
                if (value == 'settings') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsPage()),
                  );
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem<String>(
                  value: 'settings',
                  child: Text(
                    'Settings',
                    style: TextStyle(fontFamily: "poppins"),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!hasAcceptedTerms) {
      return TermsOverlay(onTermsAccepted: _onTermsAccepted);
    }

    return const ProfileContent();
  }
}