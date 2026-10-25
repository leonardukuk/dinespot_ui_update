import 'package:flutter/foundation.dart';

enum AppRole { admin, customer, rider }

class RiderProfile {
  const RiderProfile({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.vehicleType,
  });

  final String fullName;
  final String email;
  final String phone;
  final String vehicleType;
}

class AppSession extends ChangeNotifier {
  AppSession._();

  static final instance = AppSession._();

  static const adminUsername = 'admin1';
  static const adminPassword = 'password123';
  static const customerUsername = 'user1';
  static const customerPassword = 'password123';
  static const riderUsername = 'rider1';
  static const riderPassword = 'password123';

  AppRole? _role;
  String? _username;
  final Map<String, String> _customerAccounts = {};
  final Map<String, String> _riderAccounts = {};
  final Map<String, RiderProfile> _riderProfiles = {};

  AppRole? get role => _role;
  String? get username => _username;
  RiderProfile? get riderProfile =>
      _username == null ? null : _riderProfiles[_username];

  bool registerCustomer(String username, String password) {
    final normalizedUsername = username.trim().toLowerCase();
    if (normalizedUsername.isEmpty ||
        normalizedUsername == adminUsername ||
        normalizedUsername == customerUsername ||
        normalizedUsername == riderUsername ||
        _riderAccounts.containsKey(normalizedUsername) ||
        _customerAccounts.containsKey(normalizedUsername)) {
      return false;
    }

    _customerAccounts[normalizedUsername] = password;
    _role = AppRole.customer;
    _username = normalizedUsername;
    notifyListeners();
    return true;
  }

  bool registerRider(
    String username,
    String password, {
    required RiderProfile profile,
  }) {
    final normalizedUsername = username.trim().toLowerCase();
    if (normalizedUsername.isEmpty ||
        normalizedUsername == adminUsername ||
        normalizedUsername == customerUsername ||
        normalizedUsername == riderUsername ||
        _customerAccounts.containsKey(normalizedUsername) ||
        _riderAccounts.containsKey(normalizedUsername)) {
      return false;
    }

    _riderAccounts[normalizedUsername] = password;
    _riderProfiles[normalizedUsername] = profile;
    _role = AppRole.rider;
    _username = normalizedUsername;
    notifyListeners();
    return true;
  }

  bool signIn(String username, String password) {
    final normalizedUsername = username.trim().toLowerCase();
    if (normalizedUsername == adminUsername && password == adminPassword) {
      _role = AppRole.admin;
      _username = adminUsername;
    } else if (normalizedUsername == customerUsername &&
        password == customerPassword) {
      _role = AppRole.customer;
      _username = customerUsername;
    } else if (_customerAccounts[normalizedUsername] == password) {
      _role = AppRole.customer;
      _username = normalizedUsername;
    } else {
      return false;
    }
    notifyListeners();
    return true;
  }

  bool signInRider(String username, String password) {
    final normalizedUsername = username.trim().toLowerCase();
    final isDemoRider =
        normalizedUsername == riderUsername && password == riderPassword;
    if (!isDemoRider && _riderAccounts[normalizedUsername] != password) {
      return false;
    }

    _role = AppRole.rider;
    _username = normalizedUsername;
    notifyListeners();
    return true;
  }

  void signOut() {
    _role = null;
    _username = null;
    notifyListeners();
  }
}
