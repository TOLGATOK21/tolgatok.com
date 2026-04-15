import 'package:flutter/material.dart';
import 'package:flutter_web/screens/desktop/widgets/menu_bar.dart';
import 'package:flutter_web/screens/desktop/widgets/desktop_folder.dart';
import 'package:flutter_web/screens/desktop/widgets/dock_bar.dart';
import 'package:flutter_web/screens/desktop/widgets/macos_window.dart';
import 'package:flutter_web/screens/desktop/widgets/terminal_window.dart';
import 'package:flutter_web/screens/desktop/pages/about_page.dart';
import 'package:flutter_web/screens/desktop/pages/projects_page.dart';
import 'package:flutter_web/screens/desktop/pages/other_page.dart';

class DesktopScreen extends StatefulWidget {
  const DesktopScreen({super.key});

  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen> {
  // Açık pencerelerin listesi (sıralama = z-order, son eleman en üstte)
  final List<_WindowState> _openWindows = [];
  int _nextZIndex = 0;
  bool _initialized = false;

  final List<_FolderData> _folders = [
    _FolderData(id: 'about', name: 'Hakkımda', icon: Icons.person),
    _FolderData(id: 'projects', name: 'Projelerim', icon: Icons.work),
    _FolderData(id: 'other', name: 'Diğer', icon: Icons.folder),
    _FolderData(id: 'terminal', name: 'Terminal', icon: Icons.terminal),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      // Terminal'i açılışta ortada aç
      final size = MediaQuery.of(context).size;
      _openWindows.add(_WindowState(
        id: 'terminal',
        position: Offset(
          (size.width - 700) / 2,
          (size.height - 480) / 2,
        ),
        zIndex: _nextZIndex++,
      ));
    }
  }

  void _openWindow(String folderId) {
    setState(() {
      // Zaten açıksa öne getir
      final existing = _openWindows.where((w) => w.id == folderId).toList();
      if (existing.isNotEmpty) {
        _bringToFront(folderId);
        return;
      }

      final size = MediaQuery.of(context).size;
      // Her yeni pencereyi biraz kaydırarak aç (cascade efekti)
      final offset = (_openWindows.length % 5) * 30.0;
      _openWindows.add(_WindowState(
        id: folderId,
        position: Offset(
          (size.width - 700) / 2 + offset,
          (size.height - 480) / 2 + offset,
        ),
        zIndex: _nextZIndex++,
      ));
    });
  }

  void _closeWindow(String windowId) {
    setState(() {
      _openWindows.removeWhere((w) => w.id == windowId);
    });
  }

  void _bringToFront(String windowId) {
    setState(() {
      final window = _openWindows.firstWhere((w) => w.id == windowId);
      window.zIndex = _nextZIndex++;
    });
  }

  void _onDrag(String windowId, DragUpdateDetails details) {
    setState(() {
      final window = _openWindows.firstWhere((w) => w.id == windowId);
      window.position += details.delta;
    });
  }

  bool _isWindowOpen(String id) {
    return _openWindows.any((w) => w.id == id);
  }

  Widget _buildWindowContent(String folderId) {
    switch (folderId) {
      case 'about':
        return const AboutPage();
      case 'projects':
        return const ProjectsPage();
      case 'other':
        return const OtherPage();
      default:
        return const SizedBox.shrink();
    }
  }

  String _getWindowTitle(String folderId) {
    return _folders.firstWhere((f) => f.id == folderId).name;
  }

  @override
  Widget build(BuildContext context) {
    // z-order'a göre sırala (düşük index altta, yüksek üstte)
    final sortedWindows = List<_WindowState>.from(_openWindows)
      ..sort((a, b) => a.zIndex.compareTo(b.zIndex));

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A1A2E),
                  Color(0xFF16213E),
                  Color(0xFF0F3460),
                ],
              ),
            ),
          ),

          // Desktop folders
          Positioned(
            top: 40,
            right: 20,
            child: Column(
              children: _folders.map((folder) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: DesktopFolder(
                    name: folder.name,
                    icon: folder.icon,
                    isOpen: _isWindowOpen(folder.id),
                    onDoubleTap: () => _openWindow(folder.id),
                  ),
                );
              }).toList(),
            ),
          ),

          // Pencereler (z-order sırasına göre)
          for (final window in sortedWindows)
            Positioned(
              key: ValueKey(window.id),
              left: window.position.dx,
              top: window.position.dy,
              child: window.id == 'terminal'
                  ? TerminalWindow(
                      onClose: () => _closeWindow(window.id),
                      onTapWindow: () => _bringToFront(window.id),
                      onDragUpdate: (details) => _onDrag(window.id, details),
                    )
                  : MacosWindow(
                      title: _getWindowTitle(window.id),
                      onClose: () => _closeWindow(window.id),
                      onTapWindow: () => _bringToFront(window.id),
                      onDragUpdate: (details) => _onDrag(window.id, details),
                      child: _buildWindowContent(window.id),
                    ),
            ),

          // Menu bar (top — her zaman en üstte)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: MacMenuBar(),
          ),

          // Dock (bottom — her zaman en üstte)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Center(
              child: DockBar(
                onFolderTap: _openWindow,
                folders: _folders.map((f) => {'id': f.id, 'name': f.name}).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FolderData {
  final String id;
  final String name;
  final IconData icon;

  _FolderData({required this.id, required this.name, required this.icon});
}

class _WindowState {
  final String id;
  Offset position;
  int zIndex;

  _WindowState({
    required this.id,
    required this.position,
    required this.zIndex,
  });
}
