import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/settings.dart';

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: true);
    final theme = Theme.of(context);
    final keepAwake = settingsProvider.keepAwake;
    final fadeEnabled = settingsProvider.fadeEnabled;
    final fadeMinutes = settingsProvider.fadeMinutes;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            title: Text('Keep Screen Awake', style: theme.textTheme.bodyMedium),
            subtitle: Text('Prevents auto-lock while app is in foreground', style: theme.textTheme.labelSmall),
            value: keepAwake,
            onChanged: (v) => settingsProvider.setKeepAwake(v),
          ),
          Divider(thickness: 1, color: theme.dividerColor),
          SwitchListTile(
            title: Text('Enable Fade Effect', style: theme.textTheme.bodyMedium),
            subtitle: Text('Gradually deterioates the image over time', style: theme.textTheme.labelSmall),
            value: fadeEnabled,
            onChanged: (v) => settingsProvider.setFadeEnabled(v),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('Time', style: Theme.of(context).textTheme.bodyMedium),
                const Spacer(),
                Text('$fadeMinutes minute${(fadeMinutes > 1) ? 's' : ''}', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Slider.adaptive(
              value: fadeMinutes.toDouble(),
              min: 1,
              max: 60,
              divisions: 59,
              label: '$fadeMinutes min',
              onChanged: fadeEnabled ? (v) => settingsProvider.setFadeMinutes(v.round()) : null,
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
