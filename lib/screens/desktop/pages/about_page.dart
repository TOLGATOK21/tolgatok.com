import 'package:flutter/material.dart';
import 'package:flutter_web/config/constants.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar & Name
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppConstants.accentColor,
                      AppConstants.accentColor.withValues(alpha: 0.6),
                    ],
                  ),
                ),
                child: const Icon(Icons.person, size: 40, color: Colors.white),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOLGA TOK',
                    style: TextStyle(
                      color: AppConstants.textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'AI ve Mobil Geliştirici',
                    style: TextStyle(
                      color: AppConstants.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          const _SectionTitle('Hakkımda'),
          const SizedBox(height: 8),
          const Text(
            'Merhaba! Ben Tolga. Flutter ile son kullanıcı için mobil uygulamalar geliştiriyorum '
            'Kalan zamanlarımda Yapay zeka, makine öğrenmesi ve veri bilimi alanında kendimi geliştirmeye çalışıyorum'
            'Meraklısına: Bu site macOS masaüstü simülasyonu olarak Flutter Web ile geliştirilmiştir.',
            style: TextStyle(
              color: AppConstants.textSecondary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          const _SectionTitle('Yetenekler'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _skillChip('Flutter'),
              _skillChip('Dart'),
              _skillChip('Firebase'),
              _skillChip('REST API'),
              _skillChip('Git'),
              _skillChip('UI/UX'),
              _skillChip('Makine Öğrenmesi'),
              _skillChip('Pandas'),
              _skillChip('NumPy'),
            ],
          ),
          const SizedBox(height: 24),
          const _SectionTitle('İletişim'),
          const SizedBox(height: 12),
          const _ContactRow(icon: Icons.email, text: 'tolgatnh@gmail.com'),
          const SizedBox(height: 8),
          const _ContactRow(
            icon: Icons.language,
            text: 'github.com/TOLGATOK21',
          ),
          const SizedBox(height: 8),
          const _ContactRow(icon: Icons.location_on, text: 'Konya, Türkiye'),
        ],
      ),
    );
  }

  static Widget _skillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppConstants.accentColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppConstants.accentColor.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppConstants.accentColor,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppConstants.textColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ContactRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppConstants.accentColor, size: 18),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            color: AppConstants.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
