import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linode_flutter/controllers/firebase_auth.dart';
import 'package:linode_flutter/register.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  @override
  Widget build(BuildContext context) {
    const backgroundColor = const Color(0xFFBE1D1FB);
    const buttonColor = const Color(0xFFB392E4F);

    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Login',
              style: GoogleFonts.manrope(
                  textStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.45,
                child: SvgPicture.asset("assets/login.svg",
                    semanticsLabel: 'Acme Logo')),
            Padding(
              padding: const EdgeInsets.only(top: 13.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 13.0),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: buttonColor,
                ),
                onPressed: () {
                  loginUsingFirebase(
                      emailController.text, passwordController.text);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login',
                      style: GoogleFonts.manrope(),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                children: [
                  Text(
                    "Not registered yet?",
                    style:
                        GoogleFonts.manrope(textStyle: TextStyle(fontSize: 16)),
                  ),
                  InkWell(
                    child: Text(
                      " Create an Account",
                      style: GoogleFonts.manrope(
                          textStyle: TextStyle(
                              color: buttonColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterUser()),
                      );
                    },
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
