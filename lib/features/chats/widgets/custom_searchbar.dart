import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../controller/chat_user_controller.dart';
import '../screens/inbox_screen.dart';

class CustomSearchbar extends StatefulWidget {
  const CustomSearchbar({super.key});

  @override
  State<CustomSearchbar> createState() => _CustomSearchbarState();
}

class _CustomSearchbarState extends State<CustomSearchbar> {
  final _controller = ChatUserController();
  final _searchController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = false;

  Future<void> _search(String query) async {
    setState(() => _isLoading = true);
    final results = await _controller.getUsersBySearch(query);
    setState(() {
      _users = results;
      _isLoading = false;
    });
  }

  void _openInbox(Map<String, dynamic> user) {
    final currentUserId = _auth.currentUser!.uid;
    final selectedUserId = user['userId'] ?? '';

    print('Current User: $currentUserId');
    print('Selected User: $selectedUserId');

    if (selectedUserId == currentUserId) {
      print('Own profile tapped - nothing happens');
      return;
    }

    print('Opening inbox of: $selectedUserId');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InboxScreen(
          otherUserId: selectedUserId,
          otherUserName: '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}',
          otherUserImage: user['profileImage'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.done,
              onChanged: _search,
              onEditingComplete: () => FocusScope.of(context).unfocus(),
              style: const TextStyle(
                fontFamily: "poppins",
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
              cursorColor: Colors.grey.shade800,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Iconsax.search_normal,
                  color: Colors.deepPurple.shade700,
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: "Search user....",
                hintStyle: TextStyle(color: Colors.grey.shade900, fontSize: 15),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300.withOpacity(0.9),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
                ),
              ),
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            )
          else if (_users.isEmpty && _searchController.text.isNotEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text("No users found"),
            )
          else if (_users.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  final firstName = user['firstName']?.toString() ?? '';
                  final lastName = user['lastName']?.toString() ?? '';
                  final fullName = '$firstName $lastName'.trim();

                  final profileImage = user['profileImage'];
                  final avatar = profileImage != null
                      ? MemoryImage(base64Decode(profileImage))
                      : null;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: avatar,
                      backgroundColor: Colors.grey.shade300,
                      child: avatar == null
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                    title: Text(
                      fullName.isNotEmpty ? fullName : 'Unnamed User',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    onTap: () => _openInbox(user),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
