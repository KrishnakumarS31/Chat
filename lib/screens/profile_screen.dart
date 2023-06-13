import 'package:chat/screens/home_screen.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import 'components/components.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.email, required this.userName});
  final String userName;
  final String email;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            const Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              widget.userName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 2,
            ),
            DrawerList(
              isSelected: false,
              title: 'Groups',
              icon: Icons.group,
              press: () {
                nextScreenReplacement(context, const HomeScreen());
              },
            ),
            DrawerList(
              isSelected: true,
              title: 'Profile',
              icon: Icons.account_circle,
              press: () {},
            ),
            DrawerList(
              isSelected: false,
              title: 'Logout',
              icon: Icons.exit_to_app,
              press: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure want to logout?'),
                      actions: [
                        LogoutButton(
                          icon: Icons.cancel,
                          color: Colors.red,
                          onPress: () {
                            Navigator.pop(context);
                          },
                        ),
                        LogoutButton(
                          icon: Icons.done,
                          color: Colors.green,
                          onPress: () async {
                            await authService.signOut();
                            if (!mounted) return;
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                                (route) => false);
                          },
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 170),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.account_circle,
              size: 200,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 15,
            ),
            ProfileNameEmail(
              title: 'User Name :',
              content: widget.userName,
            ),
            const Divider(height: 20),
            ProfileNameEmail(
              title: 'Email :',
              content: widget.email,
            )
          ],
        ),
      ),
    );
  }
}
