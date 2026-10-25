import 'package:flutter/material.dart';

import 'signup.dart';
import 'viewfullmenu.dart';

class CafePizzaHomePage extends StatelessWidget {
  const CafePizzaHomePage({super.key, this.customerApp});

  final Widget? customerApp;

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      _MenuAction(label: 'View full menu', destination: const FullMenuPage()),
      _MenuAction(label: 'Find us', destination: const FindUsPage()),
      _MenuAction(label: 'Sign up', destination: const SignUpPage()),
      if (customerApp != null)
        _MenuAction(label: 'Customer ordering', destination: customerApp!),
      _MenuAction(label: 'Get the app', destination: const GetAppPage()),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFD7C59F),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 380,
            decoration: BoxDecoration(
              color: const Color(0xFFEDE2D5),
              border: Border.all(color: const Color(0xFF7A1478), width: 3),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 300,
                      height: 300,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF7A1478),
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(150),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'lib/images/pizza1.jpg',
                          fit: BoxFit.cover,
                          height: 300,
                          width: 300,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Cafepizza',
                      style: TextStyle(
                        fontSize: 54,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E0F0A),
                        letterSpacing: -2,
                        fontFamily: 'Georgia',
                      ),
                    ),
                    const Text(
                      'Comfort brewed daily',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2A211B),
                        fontFamily: 'Georgia',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: 280,
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          'lib/images/icecoffe1.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    ...menuItems.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ActionButton(
                          label: item.label,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => item.destination,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 54,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuAction {
  const _MenuAction({required this.label, required this.destination});

  final String label;
  final Widget destination;
}

class _ActionButton extends StatefulWidget {
  const _ActionButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: widget.onPressed,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: 300,
          height: 58,
          transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
          decoration: BoxDecoration(
            color: _hovered ? const Color(0xFFFFF9F2) : const Color(0xFFF9F4F1),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _hovered ? 0.16 : 0.08),
                blurRadius: _hovered ? 14 : 8,
                offset: Offset(0, _hovered ? 6 : 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.label,
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xFF1E1E1E),
                fontWeight: FontWeight.w500,
                fontFamily: 'Georgia',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FindUsPage extends StatelessWidget {
  const FindUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find us')),
      backgroundColor: const Color(0xFFF7F0E6),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: const Color(0xFF5A3122),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1200&q=80',
                  ),
                  fit: BoxFit.cover,
                  opacity: 0.85,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Cafepizza Downtown',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              '42 Maple Street, New York, NY',
              style: TextStyle(fontSize: 18, color: Color(0xFF4E4E4E)),
            ),
            const SizedBox(height: 18),
            const Row(
              children: [
                Icon(Icons.access_time, color: Color(0xFF7A1478)),
                SizedBox(width: 10),
                Text('Open daily • 8:00 AM - 11:00 PM'),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(Icons.directions_car, color: Color(0xFF7A1478)),
                SizedBox(width: 10),
                Text('Free parking behind the building'),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A1478),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Get directions'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GetAppPage extends StatelessWidget {
  const GetAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Get the app')),
      backgroundColor: const Color(0xFFF7F0E6),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFF7A1478), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.qr_code_2,
                  size: 130,
                  color: Color(0xFF7A1478),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Download our app for rewards, ordering and pickup',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('App download started!')),
                  );
                },
                icon: const Icon(Icons.download),
                label: const Text('Download for iOS'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A1478),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Android download started!')),
                  );
                },
                icon: const Icon(Icons.android),
                label: const Text('Download for Android'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF7A1478),
                  side: const BorderSide(color: Color(0xFF7A1478), width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
