import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../chats/controller/chat_user_controller.dart';
import '../../../../chats/screens/inbox_screen.dart';

class EmployeeSearchBar extends StatefulWidget {
  const EmployeeSearchBar({super.key});

  @override
  State<EmployeeSearchBar> createState() => _EmployeeSearchBarState();
}

class _EmployeeSearchBarState extends State<EmployeeSearchBar> {
  final _controller = ChatUserController();
  final _searchController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _focusNode = FocusNode();
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = false;
  String _currentQuery = '';
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      setState(() {
        _showResults = false;
      });
    }
  }

  Future<void> _search(String query) async {
    if (query.isEmpty) {
      setState(() {
        _users = [];
        _isLoading = false;
        _currentQuery = '';
        _showResults = false;
      });
      return;
    }

    if (query == _currentQuery) return;

    setState(() {
      _isLoading = true;
      _currentQuery = query;
      _showResults = true;
    });

    try {
      final results = await _controller.getUsersBySearch(query);
      setState(() {
        _users = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _users = [];
      });
    }
  }

  void _openInbox(Map<String, dynamic> user) {
    final currentUserId = _auth.currentUser!.uid;
    final selectedUserId = user['userId'] ?? '';

    if (selectedUserId == currentUserId) return;

    _focusNode.unfocus();

    setState(() {
      _showResults = false;
    });

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
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            focusNode: _focusNode,
            controller: _searchController,
            textInputAction: TextInputAction.done,
            onChanged: _search,
            onEditingComplete: () {
              _focusNode.unfocus();
              setState(() {
                _showResults = false;
              });
            },
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
                  color: Colors.grey.shade300.withValues(alpha: 0.9),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
              ),
            ),
          ),
        ),
        if (_showResults && _isLoading)
          const Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          )
        else if (_showResults &&
            _users.isEmpty &&
            _searchController.text.isNotEmpty)
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text("No users found"),
          )
        else if (_showResults && _users.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 22),
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
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

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: avatar,
                        backgroundColor: Colors.grey.shade300,
                        child: avatar == null
                            ? const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 18,
                        )
                            : null,
                      ),
                      title: Text(
                        fullName.isNotEmpty ? fullName : 'Unnamed User',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      visualDensity: const VisualDensity(
                        horizontal: 0,
                        vertical: -4,
                      ),
                      onTap: () => _openInbox(user),
                    ),
                  );
                },
              ),
            ),
      ],
    );
  }
}
