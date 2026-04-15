import 'package:flutter/material.dart';
import 'package:flutter_web/config/constants.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Projelerim',
            style: TextStyle(
              color: AppConstants.textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _ProjectCard(
            title: 'macOS Desktop Simülasyonu',
            description: 'Flutter Web ile geliştirilmiş macOS masaüstü simülasyonu.',
            tags: ['Flutter', 'Web', 'UI'],
            color: const Color(0xFF5AC8FA),
          ),
          const SizedBox(height: 12),
          _ProjectCard(
            title: 'E-Ticaret Uygulaması',
            description: 'Mobil ve web platformlarında çalışan e-ticaret çözümü.',
            tags: ['Flutter', 'Firebase', 'Stripe'],
            color: const Color(0xFFFF9500),
          ),
          const SizedBox(height: 12),
          _ProjectCard(
            title: 'Chat Uygulaması',
            description: 'Gerçek zamanlı mesajlaşma uygulaması.',
            tags: ['Flutter', 'WebSocket', 'Node.js'],
            color: const Color(0xFF30D158),
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final List<String> tags;
  final Color color;

  const _ProjectCard({
    required this.title,
    required this.description,
    required this.tags,
    required this.color,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _hovering
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hovering
                ? widget.color.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.code, color: widget.color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: AppConstants.textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      color: AppConstants.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: widget.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: widget.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            color: widget.color,
                            fontSize: 11,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
