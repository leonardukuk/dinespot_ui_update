import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Keeps each user's profile photo in memory while the app is running.
class AvatarStore extends ChangeNotifier {
  AvatarStore._();

  static final instance = AvatarStore._();

  final Map<String, Uint8List> _photos = {};

  Uint8List? photoOf(String username) => _photos[username];

  void setPhoto(String username, Uint8List bytes) {
    _photos[username] = bytes;
    notifyListeners();
  }
}

/// Round profile picture. Shows the user's photo, or their first letter
/// when no photo has been chosen yet. If [editable] is true, tapping it
/// lets the user pick a new photo from their gallery / files.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.username,
    this.size = 56,
    this.editable = false,
  });

  final String username;
  final double size;
  final bool editable;

  Future<void> _pickPhoto(BuildContext context) async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 600,
        imageQuality: 85,
      );
      if (image == null) return;
      final bytes = await image.readAsBytes();
      AvatarStore.instance.setPhoto(username, bytes);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the photo picker.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AvatarStore.instance,
      builder: (context, _) {
        final photo = AvatarStore.instance.photoOf(username);
        final initial = username.isEmpty ? '?' : username[0].toUpperCase();
        final inner = size - 6;

        final avatar = Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFE2A25E), Color(0xFF9B5735)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF533324).withValues(alpha: 0.22),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipOval(
            child: photo != null
                ? Image.memory(
                    photo,
                    width: inner,
                    height: inner,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: inner,
                    height: inner,
                    alignment: Alignment.center,
                    color: const Color(0xFFF0E4D8),
                    child: Text(
                      initial,
                      style: TextStyle(
                        fontSize: size * 0.42,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF76513B),
                      ),
                    ),
                  ),
          ),
        );

        if (!editable) return avatar;

        return Tooltip(
          message: 'Change photo',
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _pickPhoto(context),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  avatar,
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      padding: EdgeInsets.all(size * 0.09),
                      decoration: BoxDecoration(
                        color: const Color(0xFF34221B),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        size: size * 0.22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
