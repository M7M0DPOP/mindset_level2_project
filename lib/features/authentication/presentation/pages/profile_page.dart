import 'package:flutter/material.dart';
import 'package:mindset_level2_project/features/authentication/data/repositories/user_repo_impl.dart';
import 'package:mindset_level2_project/features/authentication/domain/entities/user_entity.dart';
import '../../../../core/app_themes.dart';
import 'login_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mindset_level2_project/main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserEntity get userEntity => getIt<UserRepoImpl>().loadUser();

  Future<String?> _getUserEmail() async {
    return userEntity.email;
  }

  String? _getUserId() {
    return userEntity.userId;
  }

  String? _getUserName() {
    return userEntity.userName;
  }

  String? _getUserImage() {
    return userEntity.userImage;
  }

  Future<void> _logout(BuildContext context) async {
    getIt<UserRepoImpl>().clearUser();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  void initState() {
    super.initState();
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF121714),
          title: Text('Logout', style: TextStyle(color: AppThemes.textColor)),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: AppThemes.lightGreen),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancel', style: TextStyle(color: AppThemes.gray)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _logout(context);
              },
              child: Text('Logout', style: TextStyle(color: AppThemes.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.primaryColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF121714),
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(color: AppThemes.textColor, fontSize: 25),
        ),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<String?>(
        future: _getUserEmail(),
        builder: (context, snapshot) {
          final email = snapshot.data ?? 'user@example.com';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppThemes.secondaryColor,
                  child: CachedNetworkImage(
                    imageUrl: _getUserImage() ?? "",
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(
                      Icons.person,
                      size: 60,
                      color: AppThemes.textColor,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    color: AppThemes.textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  email,
                  style: const TextStyle(
                    color: Color(0xFF9EB8A8),
                    fontSize: 16,
                  ),
                ),
                Text(
                  _getUserName() ?? "Example",
                  style: const TextStyle(
                    color: Color(0xFF9EB8A8),
                    fontSize: 16,
                  ),
                ),
                Text(
                  _getUserId() ?? "user id",
                  style: const TextStyle(
                    color: Color(0xFF9EB8A8),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 90),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.2),
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                    onPressed: () => _showLogoutDialog(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.logout),
                        SizedBox(width: 8),
                        Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
