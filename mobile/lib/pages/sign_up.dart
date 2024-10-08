import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    labelText: "Display name",
                    labelStyle: const TextStyle(
                      color: Colors.black54,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        width: 2,
                      ),
                    ),
                    floatingLabelStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    focusColor: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: const TextStyle(
                      color: Colors.black54,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        width: 2,
                      ),
                    ),
                    floatingLabelStyle: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: const TextStyle(
                      color: Colors.black54,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        width: 2,
                      ),
                    ),
                    floatingLabelStyle: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    labelText: "Comfirm password",
                    labelStyle: const TextStyle(
                      color: Colors.black54,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        width: 2,
                      ),
                    ),
                    floatingLabelStyle: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.green.shade600,
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 2,
                        color: Colors.black45,
                        indent: 20,
                        endIndent: 20,
                      ),
                    ),
                    Text(
                      "or continue with",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black45,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 2,
                        color: Colors.black45,
                        indent: 20,
                        endIndent: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Ink.image(
                    width: 56,
                    height: 56,
                    image: const AssetImage(
                      'assets/images/google.png',
                    ),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () => {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
