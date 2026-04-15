import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web/config/constants.dart';
import 'package:flutter_web/services/terminal_command_handler.dart';

class TerminalWindow extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback? onTapWindow;
  final void Function(DragUpdateDetails)? onDragUpdate;

  const TerminalWindow({
    super.key,
    required this.onClose,
    this.onTapWindow,
    this.onDragUpdate,
  });

  @override
  State<TerminalWindow> createState() => _TerminalWindowState();
}

class _TerminalWindowState extends State<TerminalWindow> {
  final TerminalCommandHandler _handler = TerminalCommandHandler();
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final List<_OutputLine> _outputLines = [];
  bool _introPlaying = true;
  int _introIndex = 0;

  // Açılış animasyonu script'i
  static const _introScript = [
    _IntroLine(text: 'Last login: Sal Nis 15 10:32:01 on ttys000', delay: 300),
    _IntroLine(text: '\$ whoami', delay: 500, isCommand: true),
    _IntroLine(text: 'tolga', delay: 300),
    _IntroLine(text: '\$ cat welcome.txt', delay: 600, isCommand: true),
    _IntroLine(text: '', delay: 150),
    _IntroLine(text: '  ╔══════════════════════════════════════╗', delay: 40),
    _IntroLine(text: '  ║                                      ║', delay: 40),
    _IntroLine(text: '  ║     Hoş geldiniz! 👋                 ║', delay: 40),
    _IntroLine(text: '  ║                                      ║', delay: 40),
    _IntroLine(text: '  ║     Ben Tolga. Flutter ile son       ║', delay: 40),
    _IntroLine(text: '  ║     kullanıcı için projeler          ║', delay: 40),
    _IntroLine(text: '  ║     geliştiriyorum.                  ║', delay: 40),
    _IntroLine(text: '  ║                                      ║', delay: 40),
    _IntroLine(text: '  ║     Yapay zeka, makine öğrenmesi ve  ║', delay: 40),
    _IntroLine(text: '  ║     veri odaklı sistemler üzerine    ║', delay: 40),
    _IntroLine(text: '  ║     kendimi geliştiriyorum.          ║', delay: 40),
    _IntroLine(text: '  ║                                      ║', delay: 40),
    _IntroLine(text: '  ╚══════════════════════════════════════╝', delay: 40),
    _IntroLine(text: '', delay: 200),
    _IntroLine(text: "\$ echo \"Komut yazmayı deneyin! 'help' yazarak başlayın.\"", delay: 500, isCommand: true),
    _IntroLine(text: "Komut yazmayı deneyin! 'help' yazarak başlayın.", delay: 300),
    _IntroLine(text: '', delay: 200),
  ];

  @override
  void initState() {
    super.initState();
    _playIntro();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _playIntro() {
    if (_introIndex >= _introScript.length) {
      setState(() => _introPlaying = false);
      _focusNode.requestFocus();
      return;
    }

    final line = _introScript[_introIndex];
    Timer(Duration(milliseconds: line.delay), () {
      if (!mounted) return;
      setState(() {
        _outputLines.add(_OutputLine(
          text: line.text,
          type: line.isCommand ? _LineType.command : _LineType.output,
        ));
        _introIndex++;
      });
      _scrollToBottom();
      _playIntro();
    });
  }

  void _executeCommand(String input) {
    // Prompt satırını çıktıya ekle
    setState(() {
      _outputLines.add(_OutputLine(
        text: '${_handler.prompt}$input',
        type: _LineType.prompt,
      ));
    });

    final result = _handler.execute(input);

    setState(() {
      if (result == null) {
        // clear komutu
        _outputLines.clear();
      } else if (result.isNotEmpty) {
        _outputLines.add(_OutputLine(text: result, type: _LineType.output));
      }
    });

    _inputController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final windowWidth = (screenSize.width * 0.55).clamp(420.0, 750.0);
    final windowHeight = (screenSize.height * 0.6).clamp(320.0, 520.0);

    return GestureDetector(
      onTap: widget.onTapWindow,
      child: Container(
        width: windowWidth,
        height: windowHeight,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1B26),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 40,
              spreadRadius: 8,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              _buildTitleBar(),
              Expanded(child: _buildTerminalBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleBar() {
    return GestureDetector(
      onPanUpdate: widget.onDragUpdate,
      child: Container(
      height: 38,
      decoration: const BoxDecoration(
        color: Color(0xFF2A2B3D),
        border: Border(bottom: BorderSide(color: Color(0xFF1A1A2A), width: 1)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          _trafficLight(AppConstants.closeButton, widget.onClose),
          const SizedBox(width: 8),
          _trafficLight(AppConstants.minimizeButton, null),
          const SizedBox(width: 8),
          _trafficLight(AppConstants.maximizeButton, null),
          const Spacer(),
          Text(
            'Terminal — ${_handler.currentPath}',
            style: const TextStyle(
              color: Colors.white70,
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

  Widget _trafficLight(Color color, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }

  Widget _buildTerminalBody() {
    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
      child: Container(
        color: const Color(0xFF1A1B26),
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Output area
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _outputLines.length,
                itemBuilder: (context, index) {
                  final line = _outputLines[index];
                  return _buildOutputLine(line);
                },
              ),
            ),
            // Input line
            if (!_introPlaying) _buildInputLine(),
          ],
        ),
      ),
    );
  }

  Widget _buildOutputLine(_OutputLine line) {
    final color = switch (line.type) {
      _LineType.prompt => const Color(0xFF7AA2F7),
      _LineType.command => const Color(0xFF7AA2F7),
      _LineType.output => const Color(0xFF9ECE6A),
    };

    if (line.type == _LineType.prompt) {
      // prompt kısmını mavi, komutu beyaz göster
      final promptEnd = line.text.indexOf('\$ ');
      if (promptEnd != -1) {
        final promptPart = line.text.substring(0, promptEnd + 2);
        final cmdPart = line.text.substring(promptEnd + 2);
        return Text.rich(
          TextSpan(children: [
            TextSpan(
              text: promptPart,
              style: const TextStyle(
                color: Color(0xFF7AA2F7),
                fontFamily: 'monospace',
                fontSize: 13,
                height: 1.7,
              ),
            ),
            TextSpan(
              text: cmdPart,
              style: const TextStyle(
                color: Color(0xFFA9B1D6),
                fontFamily: 'monospace',
                fontSize: 13,
                height: 1.7,
              ),
            ),
          ]),
        );
      }
    }

    return Text(
      line.text,
      style: TextStyle(
        color: color,
        fontFamily: 'monospace',
        fontSize: 13,
        height: 1.7,
      ),
    );
  }

  Widget _buildInputLine() {
    return Row(
      children: [
        Text(
          _handler.prompt,
          style: const TextStyle(
            color: Color(0xFF7AA2F7),
            fontFamily: 'monospace',
            fontSize: 13,
          ),
        ),
        Expanded(
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) {
              if (event is KeyDownEvent) {
                if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                  final prev = _handler.previousCommand();
                  if (prev != null) {
                    _inputController.text = prev;
                    _inputController.selection = TextSelection.collapsed(
                      offset: prev.length,
                    );
                  }
                } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                  final next = _handler.nextCommand();
                  if (next != null) {
                    _inputController.text = next;
                    _inputController.selection = TextSelection.collapsed(
                      offset: next.length,
                    );
                  }
                }
              }
            },
            child: TextField(
              controller: _inputController,
              focusNode: _focusNode,
              autofocus: true,
              style: const TextStyle(
                color: Color(0xFFA9B1D6),
                fontFamily: 'monospace',
                fontSize: 13,
              ),
              cursorColor: const Color(0xFF7AA2F7),
              cursorWidth: 8,
              cursorHeight: 15,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onSubmitted: (value) {
                _executeCommand(value);
                _focusNode.requestFocus();
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _OutputLine {
  final String text;
  final _LineType type;

  _OutputLine({required this.text, required this.type});
}

enum _LineType { prompt, command, output }

class _IntroLine {
  final String text;
  final int delay;
  final bool isCommand;

  const _IntroLine({
    required this.text,
    required this.delay,
    this.isCommand = false,
  });
}
