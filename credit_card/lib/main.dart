import 'package:flutter/material.dart';

void main() => runApp(const CreditCard());

class CreditCard extends StatelessWidget {
  const CreditCard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CreditCard - Flutter',
      home: Scaffold(
        backgroundColor: Colors.black87.withOpacity(0.85),
        body: Builder(
          builder: (context) => const CreditCardApp(),
        ),
      ),
    );
  }
}

class CreditCardApp extends StatelessWidget {
  const CreditCardApp({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'My Credit Card',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Center(
            child: Container(
              width: 400,
              height: 250,
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                gradient: LinearGradient(
                  colors: [
                    Colors.blueGrey.shade700,
                    Colors.black,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Stack(
                children: const [
                  Positioned(
                    top: 16.0,
                    right: 16.0,
                    child: Text(
                      'VISA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16.0,
                    left: 16.0,
                    child: Text(
                      'CARDHOLDER NAME',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40.0,
                    left: 16.0,
                    child: Text(
                      'John Doe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 124.0,
                    left: 16.0,
                    child: Text(
                      'CARD NUMBER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 140.0,
                    left: 16.0,
                    child: Text(
                      '**** **** **** 1234',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 190.0,
                    left: 16.0,
                    child: Text(
                      'EXPIRY DATE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 210.0,
                    left: 16.0,
                    child: Text(
                      '12/24',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 190.0,
                    right: 16.0,
                    child: Text(
                      'CVV',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 210.0,
                    right: 16.0,
                    child: Text(
                      '123',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
