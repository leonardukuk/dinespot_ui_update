import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

const _findUsEspresso = Color(0xFF34221B);
const _findUsCoffee = Color(0xFF76513B);
const _findUsCaramel = Color(0xFFC66B3D);
const _findUsCream = Color(0xFFFAF7F2);
const _findUsMuted = Color(0xFF81766F);

class FindUsPage extends StatelessWidget {
  const FindUsPage({super.key});

  static const _address = '123 Tomas Morato, Quezon City';
  static const _email = 'cafepizza@email.com';

  Future<void> _openLink(BuildContext context, Uri uri) async {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open this link right now.')),
      );
    }
  }

  Future<void> _copyAddress(BuildContext context) async {
    await Clipboard.setData(const ClipboardData(text: _address));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Address copied to clipboard.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _findUsCream,
      appBar: AppBar(
        backgroundColor: _findUsCream,
        foregroundColor: _findUsEspresso,
        elevation: 0,
        title: const Text(
          'Find us',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF533324), Color(0xFF9B5735)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Row(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0x26FFFFFF),
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox(
                          width: 58,
                          height: 58,
                          child: Icon(
                            Icons.location_on_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your CafePizza is here!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Coffee, pizza, and good company await.',
                              style: TextStyle(
                                color: Color(0xD9FFFFFF),
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _FindUsDetailCard(
                  icon: Icons.place_outlined,
                  title: 'Visit us',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        _address,
                        style: TextStyle(
                          color: _findUsEspresso,
                          fontSize: 15,
                          height: 1.45,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () => _openLink(
                                context,
                                Uri.https('www.google.com', '/maps/search/', {
                                  'api': '1',
                                  'query': _address,
                                }),
                              ),
                              icon: const Icon(Icons.directions_rounded),
                              label: const Text('Get directions'),
                              style: FilledButton.styleFrom(
                                backgroundColor: _findUsCaramel,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton(
                            onPressed: () => _copyAddress(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _findUsCoffee,
                              padding: const EdgeInsets.all(13),
                              side: const BorderSide(color: Color(0xFFEDE6DF)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                            child: const Icon(Icons.copy_rounded, size: 19),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _FindUsDetailCard(
                  icon: Icons.alternate_email_rounded,
                  title: 'Get in touch',
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () =>
                        _openLink(context, Uri(scheme: 'mailto', path: _email)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              _email,
                              style: TextStyle(
                                color: _findUsCoffee,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.open_in_new_rounded,
                            color: _findUsMuted,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const _FindUsDetailCard(
                  icon: Icons.local_cafe_outlined,
                  title: 'About us',
                  child: Text(
                    'CafePizza brings together freshly brewed coffee, '
                    'comforting pizza, and a welcoming place to enjoy good '
                    'food and good company. Whether you are stopping by for '
                    'a quick coffee or sharing a meal, we are happy to have '
                    'you here.',
                    style: TextStyle(
                      color: _findUsMuted,
                      fontSize: 14,
                      height: 1.55,
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

class _FindUsDetailCard extends StatelessWidget {
  const _FindUsDetailCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEDE6DF)),
        boxShadow: [
          BoxShadow(
            color: _findUsEspresso.withValues(alpha: 0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _findUsCaramel, size: 20),
              const SizedBox(width: 9),
              Text(
                title,
                style: const TextStyle(
                  color: _findUsEspresso,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
