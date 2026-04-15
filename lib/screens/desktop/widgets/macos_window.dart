import 'package:flutter/material.dart';
import 'package:flutter_web/config/constants.dart';

class MacosWindow extends StatelessWidget {
  final String title;
  final VoidCallback onClose;
  final VoidCallback? onTapWindow;
  final void Function(DragUpdateDetails)? onDragUpdate;
  final Widget child;
  final double? width;
  final double? height;

  const MacosWindow({
    super.key,
    required this.title,
    required this.onClose,
    required this.child,
    this.onTapWindow,
    this.onDragUpdate,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final windowWidth = width ?? (screenSize.width * 0.55).clamp(400.0, 800.0);
    final windowHeight = height ?? (screenSize.height * 0.6).clamp(300.0, 550.0);

    return GestureDetector(
      onTap: onTapWindow,
      child: Container(
        width: windowWidth,
        height: windowHeight,
        decoration: BoxDecoration(
          color: AppConstants.windowBody,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              _TitleBar(
                title: title,
                onClose: onClose,
                onDragUpdate: onDragUpdate,
              ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleBar extends StatelessWidget {
  final String title;
  final VoidCallback onClose;
  final void Function(DragUpdateDetails)? onDragUpdate;

  const _TitleBar({
    required this.title,
    required this.onClose,
    this.onDragUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: onDragUpdate,
      child: Container(
        height: 38,
        decoration: const BoxDecoration(
          color: AppConstants.windowTitleBar,
          border: Border(
            bottom: BorderSide(color: Color(0xFF1A1A2A), width: 1),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            _WindowButton(color: AppConstants.closeButton, onTap: onClose),
            const SizedBox(width: 8),
            _WindowButton(color: AppConstants.minimizeButton),
            const SizedBox(width: 8),
            _WindowButton(color: AppConstants.maximizeButton),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: AppConstants.textColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const SizedBox(width: 68),
          ],
        ),
      ),
    );
  }
}

class _WindowButton extends StatefulWidget {
  final Color color;
  final VoidCallback? onTap;

  const _WindowButton({required this.color, this.onTap});

  @override
  State<_WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<_WindowButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
            boxShadow: _hovering
                ? [BoxShadow(color: widget.color.withValues(alpha: 0.5), blurRadius: 4)]
                : null,
          ),
        ),
      ),
    );
  }
}
