import 'package:flutter/material.dart';
import 'package:flutter_web/config/constants.dart';

class DesktopFolder extends StatefulWidget {
  final String name;
  final IconData icon;
  final bool isOpen;
  final VoidCallback onDoubleTap;

  const DesktopFolder({
    super.key,
    required this.name,
    required this.icon,
    required this.isOpen,
    required this.onDoubleTap,
  });

  @override
  State<DesktopFolder> createState() => _DesktopFolderState();
}

class _DesktopFolderState extends State<DesktopFolder> {
  bool _hovering = false;
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: widget.onDoubleTap,
      onTap: () => setState(() => _selected = !_selected),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: Container(
          width: 90,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: _selected
                ? AppConstants.accentColor.withValues(alpha: 0.3)
                : _hovering
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.folder,
                size: 56,
                color: AppConstants.folderColor,
              ),
              const SizedBox(height: 4),
              Text(
                widget.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppConstants.textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.8),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
