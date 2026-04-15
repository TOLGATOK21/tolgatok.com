class VirtualFileSystem {
  late VFSNode _root;
  late VFSNode _current;
  String _currentPath = '~';

  String get currentPath => _currentPath;

  VirtualFileSystem() {
    _root = VFSNode.directory('~', children: [
      VFSNode.directory('Desktop', children: [
        VFSNode.directory('Hakkımda', children: [
          VFSNode.file('hakkimda.txt',
              '╔══════════════════════════════════════╗\n'
              '║  İsim: Tolga                         ║\n'
              '║  Rol:  Flutter Developer              ║\n'
              '║  Şehir: Türkiye                       ║\n'
              '╚══════════════════════════════════════╝\n'),
          VFSNode.file('yetenekler.txt',
              'Flutter, Dart, Firebase, REST API, Git, UI/UX\n'
              'Yapay Zeka, Makine Öğrenmesi, Veri Odaklı Sistemler'),
          VFSNode.file('iletisim.txt',
              'Email  : ornek@email.com\n'
              'GitHub : github.com/tolga\n'
              'Konum  : Türkiye'),
        ]),
        VFSNode.directory('Projelerim', children: [
          VFSNode.file('macos-sim.txt',
              'macOS Desktop Simülasyonu\n'
              'Teknolojiler: Flutter, Web, UI\n'
              'Durum: Aktif geliştirme'),
          VFSNode.file('e-ticaret.txt',
              'E-Ticaret Uygulaması\n'
              'Teknolojiler: Flutter, Firebase, Stripe\n'
              'Durum: Tamamlandı'),
          VFSNode.file('chat-app.txt',
              'Chat Uygulaması\n'
              'Teknolojiler: Flutter, WebSocket, Node.js\n'
              'Durum: Geliştiriliyor'),
        ]),
        VFSNode.directory('Diğer', children: [
          VFSNode.file('egitim.txt', 'Bilgisayar Mühendisliği — XYZ Üniversitesi'),
          VFSNode.file('hobiler.txt', 'Müzik, Oyun, Açık Kaynak Projeler'),
          VFSNode.file('notlar.txt',
              'Bu site Flutter Web ile geliştirilmiş bir\n'
              'macOS masaüstü simülasyonudur.'),
        ]),
      ]),
      VFSNode.file('welcome.txt',
          '╔══════════════════════════════════════╗\n'
          '║                                      ║\n'
          '║     Hoş geldiniz! 👋                 ║\n'
          '║                                      ║\n'
          '║     Ben Tolga.                        ║\n'
          '║     Flutter ile son kullanıcı için    ║\n'
          '║     projeler geliştiriyorum.          ║\n'
          '║                                      ║\n'
          '║     Yapay zeka, makine öğrenmesi ve   ║\n'
          '║     veri odaklı sistemler üzerine     ║\n'
          '║     kendimi geliştiriyorum.           ║\n'
          '║                                      ║\n'
          '╚══════════════════════════════════════╝'),
      VFSNode.file('.bashrc', 'export PS1="tolga@macbook:~\$ "'),
    ]);
    _current = _root;
  }

  List<String> listDir({bool showHidden = false}) {
    final items = <String>[];
    for (final child in _current.children) {
      if (!showHidden && child.name.startsWith('.')) continue;
      items.add(child.isDirectory ? '📁 ${child.name}/' : '📄 ${child.name}');
    }
    return items;
  }

  String changeDir(String target) {
    if (target == '~' || target == '') {
      _current = _root;
      _currentPath = '~';
      return '';
    }

    if (target == '..') {
      if (_current == _root) return '';
      // Walk from root to find parent
      final parent = _findParent(_root, _current);
      if (parent != null) {
        _current = parent;
        _currentPath = _buildPath(_root, _current);
      }
      return '';
    }

    if (target == '/') {
      _current = _root;
      _currentPath = '~';
      return '';
    }

    // Multi-segment path: cd Desktop/Hakkımda
    final segments = target.split('/').where((s) => s.isNotEmpty).toList();
    var node = _current;
    for (final seg in segments) {
      if (seg == '..') {
        final parent = _findParent(_root, node);
        if (parent != null) node = parent;
        continue;
      }
      if (seg == '.') continue;
      final found = node.children
          .where((c) => c.isDirectory && c.name == seg)
          .toList();
      if (found.isEmpty) {
        return 'cd: $target: Böyle bir dizin yok';
      }
      node = found.first;
    }
    _current = node;
    _currentPath = _buildPath(_root, _current);
    return '';
  }

  String readFile(String name) {
    final found = _current.children
        .where((c) => !c.isDirectory && c.name == name)
        .toList();
    if (found.isEmpty) {
      return 'cat: $name: Böyle bir dosya yok';
    }
    return found.first.content;
  }

  VFSNode? _findParent(VFSNode root, VFSNode target) {
    for (final child in root.children) {
      if (child == target) return root;
      if (child.isDirectory) {
        final result = _findParent(child, target);
        if (result != null) return result;
      }
    }
    return null;
  }

  String _buildPath(VFSNode root, VFSNode target) {
    if (root == target) return '~';
    final path = <String>[];
    _findPath(root, target, path);
    return '~/${path.join('/')}';
  }

  bool _findPath(VFSNode node, VFSNode target, List<String> path) {
    for (final child in node.children) {
      if (child == target) {
        path.add(child.name);
        return true;
      }
      if (child.isDirectory) {
        path.add(child.name);
        if (_findPath(child, target, path)) return true;
        path.removeLast();
      }
    }
    return false;
  }
}

class VFSNode {
  final String name;
  final bool isDirectory;
  final String content;
  final List<VFSNode> children;

  VFSNode._({
    required this.name,
    required this.isDirectory,
    this.content = '',
    this.children = const [],
  });

  factory VFSNode.file(String name, String content) =>
      VFSNode._(name: name, isDirectory: false, content: content);

  factory VFSNode.directory(String name, {List<VFSNode> children = const []}) =>
      VFSNode._(name: name, isDirectory: true, children: children);
}
