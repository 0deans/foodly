import 'package:flutter/material.dart';
import 'package:foodly/widgets/button_row.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.20,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/avatar.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Joe Doe',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  'text@gmail.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45),
                      ),
                      backgroundColor: Colors.yellow.shade600,
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ButtonRow(
              icon: Icons.settings,
              title: 'Settings',
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ButtonRow(
              icon: Icons.logout,
              title: 'Sign out',
              textColor: Colors.red,
              visibleIconLeft: false,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
