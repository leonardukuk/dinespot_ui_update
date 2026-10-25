import 'package:flutter/material.dart';

import 'auth.dart';
import 'riderdashboard.dart';
import 'widgets/animated_entry.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isSigningUp = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final success = _isSigningUp
        ? AppSession.instance.registerCustomer(
            _usernameController.text,
            _passwordController.text,
          )
        : AppSession.instance.signIn(
            _usernameController.text,
            _passwordController.text,
          );

    if (success) {
      return;
    }

    setState(() {
      _errorMessage = _isSigningUp
          ? 'That username is already in use.'
          : 'Incorrect username or password.';
    });
  }

  void _toggleSignUp() {
    setState(() {
      _isSigningUp = !_isSigningUp;
      _errorMessage = null;
      _formKey.currentState?.reset();
      _usernameController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    const brown = Color(0xFF76513B);
    const background = Color(0xFFA77F66);

    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/images/newbg.jpg',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final artworkHeight = (constraints.maxHeight * 0.42)
                    .clamp(220.0, 360.0)
                    .toDouble();

                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 20,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 430),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: artworkHeight),
                          FadeSlideIn(offset: 28, duration: const Duration(milliseconds: 650), child: Container(
                            margin: const EdgeInsets.fromLTRB(0, 20, 0, 28),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFBF6),
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF3E251A)
                                      .withValues(alpha: 0.2),
                                  blurRadius: 28,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Center(
                                    child: Container(
                                      width: 54,
                                      height: 54,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1E2D3),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: const Icon(
                                        Icons.local_cafe_rounded,
                                        color: Color(0xFF76513B),
                                        size: 29,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  const Text(
                                    'Cafepizza',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF3E2920),
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'Georgia',
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  Text(
                                    _isSigningUp
                                        ? 'Create your customer account'
                                        : 'Good food, good coffee, good company.',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF806D62),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 26),
                                  TextFormField(
                                    controller: _usernameController,
                                    textInputAction: TextInputAction.next,
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                      labelText: 'Username',
                                      labelStyle: const TextStyle(
                                        color: Color(0xFF806D62),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.person_outline,
                                        color: Color(0xFF87644F),
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFF7F1EA),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFE9DDD1),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFE9DDD1),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF8A5C40),
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    validator: (value) =>
                                        value == null || value.trim().isEmpty
                                        ? 'Enter your username'
                                        : null,
                                  ),
                                  const SizedBox(height: 14),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    textInputAction: _isSigningUp
                                        ? TextInputAction.next
                                        : TextInputAction.done,
                                    onFieldSubmitted: (_) =>
                                        _isSigningUp ? null : _submit(),
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      labelStyle: const TextStyle(
                                        color: Color(0xFF806D62),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.lock_outline,
                                        color: Color(0xFF87644F),
                                      ),
                                      suffixIcon: IconButton(
                                        tooltip: _obscurePassword
                                            ? 'Show password'
                                            : 'Hide password',
                                        onPressed: () => setState(
                                          () => _obscurePassword =
                                              !_obscurePassword,
                                        ),
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: const Color(0xFF87644F),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFF7F1EA),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFE9DDD1),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFE9DDD1),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF8A5C40),
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                        ? 'Enter your password'
                                        : _isSigningUp && value.length < 8
                                        ? 'Use at least 8 characters'
                                        : null,
                                  ),
                                  if (_isSigningUp) ...[
                                    const SizedBox(height: 14),
                                    TextFormField(
                                      controller: _confirmPasswordController,
                                      obscureText: _obscurePassword,
                                      textInputAction: TextInputAction.done,
                                      onFieldSubmitted: (_) => _submit(),
                                      decoration: InputDecoration(
                                        labelText: 'Confirm password',
                                        labelStyle: const TextStyle(
                                          color: Color(0xFF806D62),
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.lock_outline,
                                          color: Color(0xFF87644F),
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFFF7F1EA),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFE9DDD1),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFE9DDD1),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF8A5C40),
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Confirm your password';
                                        }
                                        if (value != _passwordController.text) {
                                          return 'Passwords do not match';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                  if (_errorMessage != null) ...[
                                    const SizedBox(height: 12),
                                    Text(
                                      _errorMessage!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Color(0xFFB3261E),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 20),
                                  FilledButton(
                                    onPressed: _submit,
                                    style: FilledButton.styleFrom(
                                      backgroundColor: brown,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 17,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 2,
                                    ),
                                    child: Text(
                                      _isSigningUp
                                          ? 'Create account'
                                          : 'Sign In',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  TextButton(
                                    onPressed: _toggleSignUp,
                                    child: Text(
                                      _isSigningUp
                                          ? 'Already have an account? Sign in'
                                          : 'New here? Sign up',
                                      style: const TextStyle(
                                        color: Color(0xFF76513B),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  if (!_isSigningUp) ...[
                                    const SizedBox(height: 4),
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute<void>(
                                            builder: (_) =>
                                                const RiderSignInPage(),
                                          ),
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: brown,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 15,
                                        ),
                                        side: const BorderSide(color: brown),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.delivery_dining_rounded,
                                      ),
                                      label: const Text(
                                        'Rider sign in',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Demo accounts and new accounts are stored '
                                    'locally for this app. Do not use a real password.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF9A887C),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
