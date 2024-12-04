import 'package:flutter/material.dart';
import 'package:foodly/providers/auth_provider.dart';
import 'package:foodly/services/google_service.dart';
import 'package:provider/provider.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Ink.image(
        width: 56,
        height: 56,
        image: const AssetImage(
          'assets/images/google.png',
        ),
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            final authProvider =
                Provider.of<AuthProvider>(context, listen: false);
            await GoogleService.signIn(context, authProvider);
          },
        ),
      ),
    );
  }
}
