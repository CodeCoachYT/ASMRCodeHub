import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  radius: 0.325,
                  colors: [
                    Colors.yellowAccent.shade400,
                    Colors.greenAccent.shade700,
                    Colors.black,
                  ],
                ),
              ),
              child: const Center(
                child: SizedBox(
                  width: 450,
                  height: 650,
                  child: ProfileCard(),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

final boxShadow = [
  BoxShadow(
    color: Colors.black.withOpacity(0.4),
    blurRadius: 10.0,
    spreadRadius: 2,
    offset: const Offset(0, 4),
  )
];

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mq = MediaQuery.of(context);

    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 10,
        sigmaY: 10,
      ),
      child: Card(
        elevation: 4,
        color: Colors.white.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(8.0),
                width: mq.size.longestSide * 0.15,
                height: mq.size.longestSide * 0.15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  boxShadow: boxShadow,
                ),
                child: Image.asset(
                  'assets/profile.png',
                ),
              ),
              Column(
                children: [
                  Text(
                    'ASMR CodeHub',
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'Fullstack-Developer',
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                        letterSpacing: 0.5,
                      ),
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Counter(
                      number: '1789',
                      description: 'Subscribers',
                    ),
                    Counter(
                      number: '18',
                      description: 'Videos',
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1.0,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RoundedSocialIcon(
                    icon: FontAwesomeIcons.github,
                    backgroundColor: Colors.black,
                  ),
                  RoundedSocialIcon(
                    icon: FontAwesomeIcons.link,
                    backgroundColor: Colors.black,
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: boxShadow,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(40.0),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.greenAccent.shade200,
                      Colors.yellowAccent.shade400,
                    ],
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // your business logic here
                    },
                    splashColor: Colors.white10,
                    borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36,
                        vertical: 12,
                      ),
                      child: FittedBox(
                        child: Center(
                          child: Text(
                            'Follow',
                            style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RoundedSocialIcon extends StatelessWidget {
  const RoundedSocialIcon({
    super.key,
    required this.icon,
    required this.backgroundColor,
  });

  final IconData icon;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: boxShadow,
      ),
      child: CircleAvatar(
        backgroundColor: backgroundColor,
        child: FaIcon(
          icon,
          color: Colors.white,
          size: 35,
        ),
      ),
    );
  }
}

class Counter extends StatelessWidget {
  const Counter({
    super.key,
    required this.number,
    required this.description,
  });

  final String number;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Text(description)
      ],
    );
  }
}
