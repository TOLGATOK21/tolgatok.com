import 'package:flutter/material.dart';
import 'package:flutter_web/config/constants.dart';

class DockBar extends StatelessWidget {
  final void Function(String id) onFolderTap;
  final List<Map<String, String>> folders;

  const DockBar({
    super.key,
    required this.onFolderTap,
    required this.folders,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppConstants.dockColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < folders.length; i++) ...[
            if (i > 0) const SizedBox(width: 6),
            _DockItem(
              icon: Icons.folder,
              tooltip: folders[i]['name']!,
              onTap: () => onFolderTap(folders[i]['id']!),
            ),
          ],
          const SizedBox(width: 6),
          Container(width: 1, height: 40, color: Colors.white24),
          const SizedBox(width: 6),
          _DockItem(
            icon: Icons.settings,
            tooltip: 'Ayarlar',
            onTap: () {},
          ),
          _DockItem(
            icon: Icons.terminal,
            tooltip: 'Terminal',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _DockItem extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _DockItem({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  State<_DockItem> createState() => _DockItemState();
}

class _DockItemState extends State<_DockItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Tooltip(
          message: widget.tooltip,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _hovering ? 52 : 44,
            height: _hovering ? 52 : 44,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: _hovering ? 0.15 : 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              widget.icon,
              color: AppConstants.folderColor,
              size: _hovering ? 28 : 24,
            ),
          ),
        ),
      ),
    );
  }
}
