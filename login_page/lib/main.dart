import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return const LoginPage();
          },
        ),
      ),
    ),
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final Duration duration = const Duration(seconds: 1);
  late final AnimationController _controller;
  late final animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  late final Animation<Offset> _loginAnimation;
  late final Animation<Offset> _registerAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );
    _loginAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.0, 0.0),
    ).animate(animation);
    _registerAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(animation);
  }

  void animate() {
    if (_loginAnimation.status != AnimationStatus.completed) {
      _controller.forward();
    } else {
      _controller.animateBack(0, duration: duration);
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mq = MediaQuery.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        SlideTransition(
          position: _loginAnimation,
          child: Padding(
            padding: EdgeInsets.all(mq.size.width * 0.15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageTitle(
                  subtitle: LinkText(
                    text: 'Don\'t have an account? ',
                    underline: 'Sign up here!',
                    onTap: () => animate(),
                  ),
                ),
                const TitledTextFormField(
                  title: 'E-Mail address',
                  hintText: 'subscribe@asmrcodehub',
                  prefixIcon: Icon(Icons.mail),
                ),
                const TitledTextFormField(
                  title: 'Password',
                  hintText: '',
                  obscureText: true,
                  prefixIcon: Icon(Icons.key),
                ),
                SignInButton(
                  text: 'Sign in',
                  onTap: () {
                    // your login logic here
                  },
                )
              ],
            ),
          ),
        ),
        SlideTransition(
          position: _registerAnimation,
          child: Padding(
            padding: EdgeInsets.all(mq.size.width * 0.15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageTitle(
                  subtitle: LinkText(
                    text: 'Already have an account? ',
                    underline: 'Sign in here!',
                    onTap: () => animate(),
                  ),
                ),
                const Row(
                  children: [
                    Expanded(
                      child: TitledTextFormField(
                        title: 'First Name',
                        hintText: '',
                        prefixIcon: Icon(Icons.person_2_rounded),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TitledTextFormField(
                        title: 'Last Name',
                        hintText: '',
                        prefixIcon: Icon(Icons.person_2_rounded),
                      ),
                    )
                  ],
                ),
                const TitledTextFormField(
                  title: 'E-Mail',
                  hintText: 'subscribe@asmrcodehub.thanks',
                  prefixIcon: Icon(Icons.mail),
                ),
                const Row(
                  children: [
                    Expanded(
                      child: TitledTextFormField(
                        title: 'Password',
                        hintText: '',
                        obscureText: true,
                        prefixIcon: Icon(Icons.key),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TitledTextFormField(
                        title: 'Repeat Password',
                        obscureText: true,
                        hintText: '',
                        prefixIcon: Icon(Icons.key),
                      ),
                    )
                  ],
                ),
                SignInButton(
                  text: 'Register',
                  onTap: () {},
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class SignInButton extends StatelessWidget {
  const SignInButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        width: 100,
        height: 40,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(40.0),
          ),
          gradient: LinearGradient(colors: [
            Colors.blue,
            Colors.lightBlue,
          ]),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: const BorderRadius.all(
            Radius.circular(40.0),
          ),
          child: InkWell(
            onTap: onTap,
            splashColor: Colors.white10,
            child: Center(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LinkText extends StatelessWidget {
  const LinkText({
    super.key,
    required this.text,
    required this.underline,
    required this.onTap,
  });

  final String text;
  final String underline;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          text: text,
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: underline,
              recognizer: TapGestureRecognizer()..onTap = onTap,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TitledTextFormField extends StatelessWidget {
  const TitledTextFormField({
    super.key,
    required this.title,
    required this.hintText,
    this.prefixIcon,
    this.obscureText = false,
  });

  final String title;
  final String hintText;
  final Widget? prefixIcon;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        TextFormField(
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12.5),
              ),
              gapPadding: 2.0,
            ),
          ),
        ),
        const SizedBox(
          height: 18,
        ),
      ],
    );
  }
}

class PageTitle extends StatelessWidget {
  const PageTitle({super.key, required this.subtitle});

  final Widget subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 36.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome to ASRM Code Hub',
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
          subtitle,
        ],
      ),
    );
  }
}
