import 'package:flutter/material.dart';
import 'package:flutter_web/config/constants.dart';

class MacMenuBar extends StatelessWidget {
  const MacMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    final months = [
      'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
      'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'
    ];
    final dateStr =
        '${days[now.weekday - 1]} ${now.day} ${months[now.month - 1]}';

    return Container(
      height: 28,
      decoration: BoxDecoration(
        color: AppConstants.menuBarColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          // Apple logo
          const Icon(Icons.apple, color: Colors.white, size: 18),
          const SizedBox(width: 16),
          _menuItem('Finder'),
          _menuItem('Dosya'),
          _menuItem('Düzenle'),
          _menuItem('Görünüm'),
          const Spacer(),
          Text(
            '$dateStr  $timeStr',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget _menuItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
