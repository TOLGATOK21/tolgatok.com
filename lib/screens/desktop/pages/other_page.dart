import 'package:flutter/material.dart';
import 'package:flutter_web/config/constants.dart';

class OtherPage extends StatelessWidget {
  const OtherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Diğer',
            style: TextStyle(
              color: AppConstants.textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _InfoTile(
            icon: Icons.school,
            title: 'Eğitim',
            subtitle: 'Bilgisayar Mühendisliği — XYZ Üniversitesi',
          ),
          _InfoTile(
            icon: Icons.music_note,
            title: 'Hobiler',
            subtitle: 'Müzik, Oyun, Açık Kaynak Projeler',
          ),
          _InfoTile(
            icon: Icons.book,
            title: 'Blog',
            subtitle: 'Yazılım üzerine yazılar (yakında)',
          ),
          _InfoTile(
            icon: Icons.download,
            title: 'CV İndir',
            subtitle: 'PDF formatında özgeçmişimi indirin',
          ),
          const SizedBox(height: 24),
          const Text(
            'Bu site hakkında',
            style: TextStyle(
              color: AppConstants.textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Bu web sitesi Flutter Web kullanılarak geliştirilmiş bir macOS '
            'masaüstü simülasyonudur. Tüm arayüz Flutter widget\'ları ile '
            'oluşturulmuştur.',
            style: TextStyle(
              color: AppConstants.textSecondary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  State<_InfoTile> createState() => _InfoTileState();
}

class _InfoTileState extends State<_InfoTile> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _hovering
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppConstants.accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(widget.icon, color: AppConstants.accentColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: AppConstants.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      color: AppConstants.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.white.withValues(alpha: 0.3),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
