import 'package:flutter/material.dart';

class AboutSheet extends StatelessWidget {
  const AboutSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final appVersion = '1.0.0';
    final appAuthor = 'digitaldementia';
    final appCopyrightYear = 2025;
    final currentYear = DateTime.now().year;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '“Congress shall make no law respecting an establishment of religion, or prohibiting the free exercise thereof; or abridging the freedom of speech, or of the press; or the right of the people peaceably to assemble, and to petition the Government for a redress of grievances.”',
            style: theme.textTheme.bodyLarge,
          ),
          SizedBox(height: 16),
          Text('U.S. Constitution Amendment I', style: theme.textTheme.headlineMedium),
          Text('  December 15, 1791', style: theme.textTheme.headlineMedium),
          SizedBox(height: 16),
          Divider(thickness: 2, color: theme.dividerColor),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Flagrant Freedom', style: theme.textTheme.labelLarge),
                SizedBox(height: 4),
                Text('version $appVersion', style: theme.textTheme.labelSmall),
                SizedBox(height: 2),
                Text(
                  '© ${(currentYear > appCopyrightYear) ? '$appCopyrightYear - $currentYear' : '$appCopyrightYear'} $appAuthor',
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
