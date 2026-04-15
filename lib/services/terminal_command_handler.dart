import 'package:flutter_web/services/virtual_file_system.dart';

class TerminalCommandHandler {
  final VirtualFileSystem _fs = VirtualFileSystem();
  final List<String> _history = [];
  int _historyIndex = -1;

  String get currentPath => _fs.currentPath;
  String get prompt => 'tolga@macbook:${_fs.currentPath}\$ ';

  /// Returns null when 'clear' command — caller should clear the screen.
  String? execute(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return '';

    _history.add(trimmed);
    _historyIndex = _history.length;

    final parts = trimmed.split(RegExp(r'\s+'));
    final cmd = parts[0];
    final args = parts.sublist(1);

    switch (cmd) {
      case 'help':
        return _helpText();
      case 'ls':
        return _ls(args);
      case 'cd':
        return _cd(args);
      case 'cat':
        return _cat(args);
      case 'pwd':
        return _fs.currentPath;
      case 'whoami':
        return 'tolga';
      case 'echo':
        return args.join(' ').replaceAll('"', '').replaceAll("'", '');
      case 'clear':
        return null;
      case 'date':
        final now = DateTime.now();
        return '${now.day}.${now.month.toString().padLeft(2, '0')}.${now.year} '
            '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
      case 'uname':
        return 'macOS-Sim Flutter/Web ARM64';
      case 'hostname':
        return 'macbook-tolga';
      case 'uptime':
        return ' 10:32:01 up 42 days, 3:14, 1 user';
      case 'neofetch':
        return _neofetch();
      case 'tree':
        return _tree();
      default:
        return 'bash: $cmd: komut bulunamadı\n'
            "Yardım için 'help' yazın.";
    }
  }

  String? previousCommand() {
    if (_history.isEmpty) return null;
    if (_historyIndex > 0) _historyIndex--;
    return _history[_historyIndex];
  }

  String? nextCommand() {
    if (_history.isEmpty) return null;
    if (_historyIndex < _history.length - 1) {
      _historyIndex++;
      return _history[_historyIndex];
    }
    _historyIndex = _history.length;
    return '';
  }

  String _ls(List<String> args) {
    final showHidden = args.contains('-a') || args.contains('-la');
    final items = _fs.listDir(showHidden: showHidden);
    if (items.isEmpty) return '(boş dizin)';
    return items.join('  ');
  }

  String _cd(List<String> args) {
    if (args.isEmpty) return _fs.changeDir('~');
    return _fs.changeDir(args[0]);
  }

  String _cat(List<String> args) {
    if (args.isEmpty) return 'cat: dosya adı belirtilmedi';
    return _fs.readFile(args[0]);
  }

  String _helpText() {
    return '╔═══════════════════════════════════════════╗\n'
        '║  Kullanılabilir Komutlar                  ║\n'
        '╠═══════════════════════════════════════════╣\n'
        '║  ls [-a]       Dizin içeriğini listele    ║\n'
        '║  cd <dizin>    Dizin değiştir             ║\n'
        '║  cd ..         Üst dizine git             ║\n'
        '║  cat <dosya>   Dosya içeriğini göster     ║\n'
        '║  pwd           Mevcut dizini göster       ║\n'
        '║  whoami        Kullanıcı adını göster     ║\n'
        '║  echo <metin>  Metin yazdır               ║\n'
        '║  tree          Dizin ağacını göster        ║\n'
        '║  neofetch      Sistem bilgisi              ║\n'
        '║  date          Tarih ve saat               ║\n'
        '║  uname         Sistem adı                  ║\n'
        '║  hostname      Makine adı                  ║\n'
        '║  clear         Ekranı temizle             ║\n'
        '║  help          Bu yardım mesajı           ║\n'
        '╚═══════════════════════════════════════════╝';
  }

  String _neofetch() {
    return '        ████████████            tolga@macbook\n'
        '      ██            ██          ──────────────\n'
        '    ██    ██    ██    ██        OS: macOS Sim (Flutter Web)\n'
        '    ██    ██    ██    ██        Host: Chrome Browser\n'
        '    ██                ██        Kernel: Dart 3.7.2\n'
        '      ██            ██         Shell: flutter-terminal\n'
        '    ██████████████████         Resolution: Web\n'
        '    ██  ██  ██  ██  ██         Theme: Tokyo Night\n'
        '    ██████████████████         Terminal: macOS-Sim Terminal\n'
        '        ██      ██             CPU: Flutter Engine\n'
        '        ██      ██             Memory: ∞ MB\n'
        '        ████    ████';
  }

  String _tree() {
    return '~/\n'
        '├── Desktop/\n'
        '│   ├── Hakkımda/\n'
        '│   │   ├── hakkimda.txt\n'
        '│   │   ├── yetenekler.txt\n'
        '│   │   └── iletisim.txt\n'
        '│   ├── Projelerim/\n'
        '│   │   ├── macos-sim.txt\n'
        '│   │   ├── e-ticaret.txt\n'
        '│   │   └── chat-app.txt\n'
        '│   └── Diğer/\n'
        '│       ├── egitim.txt\n'
        '│       ├── hobiler.txt\n'
        '│       └── notlar.txt\n'
        '├── welcome.txt\n'
        '└── .bashrc';
  }
}
