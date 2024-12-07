import 'package:flutter/material.dart';
import 'package:foodly/providers/auth_provider.dart';
import 'package:foodly/services/google_service.dart';
import 'package:foodly/widgets/button_row.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late AuthProvider authPrivder;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authPrivder = Provider.of<AuthProvider>(context);

    if (authPrivder.user == null) {
      authPrivder.getUser(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context)!;

    if (authPrivder.user == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          appLocale.profilePage,
          style: const TextStyle(
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
                Container(
                  decoration:
                      const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                    ),
                  ]),
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.20,
                    child: ClipOval(
                      child: authPrivder.user?.avatar != null
                          ? Image.network(
                              authPrivder.user!.avatar,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            )
                          : Image.asset(
                              'assets/images/avatar.jpg',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  authPrivder.user?.name ?? appLocale.noName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).textTheme.labelMedium!.color,
                  ),
                ),
                Text(
                  authPrivder.user?.email ?? appLocale.noEmail,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.labelSmall!.color,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/edit_profile');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45),
                      ),
                      backgroundColor: Colors.yellow.shade600,
                    ),
                    child: Text(
                      appLocale.editProfile,
                      style: const TextStyle(
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
              title: appLocale.settings,
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ButtonRow(
              icon: Icons.logout,
              title: appLocale.signOut,
              textColor: Colors.red,
              visibleIconLeft: false,
              onPressed: () {
                if (authPrivder.isGoogleSignIn) {
                  GoogleService.signOut(context, authPrivder);
                  debugPrint('Google sign out');
                } else {
                  authPrivder.signOut(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
